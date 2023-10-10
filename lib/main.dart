import 'dart:async';
import 'dart:core';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/home.dart';
import 'package:dependencecoping/notifications.dart';
import 'package:dependencecoping/onboarding.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/provider/locker/locker.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/provider/trigger/trigger.dart';
import 'package:dependencecoping/storage/init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://[******].supabase.co',
    anonKey: '[******]',
  );

  await notifications();

  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final app = App();

  if (kDebugMode) {
    imageCache.clear();
    runApp(app);
    return;
  }

  await SentryFlutter.init((final options) {
    options.dsn = 'https://[******]@[******].ingest.sentry.io/[******]';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1;
  }, appRunner: () => runApp(app));
}

class App extends StatefulWidget {
  App({super.key});

  final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with AssetsInitializer, TickerProviderStateMixin {
  late final AnimationController _spinnerController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  bool _spinnerActive = true;
  ThemeData? _themeData;

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _spinnerController.repeat();
    Timer(const Duration(milliseconds: 200), () {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (tryLock()) {
          unawaited(init(() {
            setState(() {
              _spinnerActive = false;
            });
            FlutterNativeSplash.remove();
          }));
        }
      });
    });
  }

  @override
  Widget build(final BuildContext context) => MaterialApp(
        navigatorKey: widget.mainNavigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Coping',
        home: Container(
          color: Colors.black,
          child: _spinnerActive
              ? Center(
                  child: AnimatedBuilder(
                    animation: _spinnerController,
                    builder: (final context, final _) => Opacity(
                      opacity: ((final double x) => (x <= .5 ? x : 1 - x) * 2)(_spinnerController.value),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcATop),
                        child: Image.asset(Assets.opaqring.path, width: 148, height: 148),
                      ),
                    ),
                  ),
                )
              : Builder(builder: (final context) {
                  final loginCubit = LoginCubit();
                  if (user != null) {
                    loginCubit.overwrite(user!, profile);
                  }

                  final staticCubit = StaticCubit();
                  if (!statics.isEmpty) {
                    staticCubit.overwrite(statics);
                  }

                  final tcb = MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
                  final themeCubit = ThemeCubit()..setBrightness(tcb);
                  if (profile != null && profile!.isLight != null) {
                    themeCubit.setBrightness(profile!.isLight! ? ThemeMode.light : ThemeMode.dark);
                  }
                  if (profile != null && profile!.color != null) {
                    themeCubit.setColor(findThemeColor(profile!.color!));
                  }
                  _themeData = themeCubit.state.data;

                  final countdownTimerCubit = CountdownTimerCubit();
                  if (resets != null) {
                    countdownTimerCubit.overwrite(resets!);
                  }

                  final goalsCubit = GoalsCubit();
                  if (goals != null) {
                    goalsCubit.overwrite(Goals(goals!));
                  }

                  final triggersCubit = TriggersCubit();
                  if (triggers != null) {
                    if (triggersLog == null) {
                      triggersCubit.overwrite(Triggers(triggers!, []));
                    } else {
                      triggersCubit.overwrite(Triggers(triggers!, triggersLog!));
                    }
                  }

                  final lockerCubit = LockerCubit();
                  if (lockerDuration != null) {
                    lockerCubit.overwrite(lockerStart ?? DateTime.now(), lockerDuration!);
                  }

                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (final _) => loginCubit),
                      BlocProvider(create: (final _) => staticCubit),
                      BlocProvider(create: (final _) => themeCubit),
                      BlocProvider(create: (final _) => countdownTimerCubit),
                      BlocProvider(create: (final _) => goalsCubit),
                      BlocProvider(create: (final _) => triggersCubit),
                      BlocProvider(create: (final _) => lockerCubit),
                    ],
                    child: BlocListener<LoginCubit, Profile?>(
                      listenWhen: (final p, final c) => p?.auth.id != c?.auth.id,
                      listener: (final context, final state) {
                        _spinnerController.reset();
                        setState(() {
                          _spinnerActive = true;
                        });
                        _spinnerController.repeat();

                        Timer(const Duration(seconds: 1), () {
                          unawaited(reset(() {
                            _spinnerController.repeat();
                            setState(() {
                              _spinnerActive = false;
                            });
                          }));
                        });
                      },
                      child: BlocListener<ThemeCubit, ThemeState>(
                        listener: (final context, final state) => setState(() {
                          _themeData = state.data;
                        }),
                        child: BlocBuilder<LoginCubit, Profile?>(
                          builder: (final context, final u) => AnimatedTheme(
                            data: _themeData!,
                            curve: Curves.slowMiddle,
                            duration: const Duration(milliseconds: 100),
                            child: Navigator(
                              onGenerateRoute: (final settings) => MaterialPageRoute(
                                settings: settings,
                                builder: (final context) => u == null ? const Onboarding() : const Home(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
        ),
      );
}
