import 'dart:async';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/pages/clock/chart.dart';
import 'package:dependencecoping/pages/clock/locker.dart';
import 'package:dependencecoping/pages/clock/modals/time_manager.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/tokens/animation.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class CountdownDisplay extends StatefulWidget {
  const CountdownDisplay({super.key});

  @override
  State<CountdownDisplay> createState() => _CountdownDisplayState();
}

class _CountdownDisplayState extends State<CountdownDisplay> {
  bool showChart = false;

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
        builder: (final context, final u) => BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
          builder: (final context, final ct) {
            final splits = ct?.splits();
            final paused = ct?.resumed == null;

            return Column(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      showChart = !showChart;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (final context, final state) => Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                            image: showChart
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(matchingImage(state.color, state.mode)),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.bottomCenter,
                                  ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: IgnorePointer(
                            child: ResetsChart(enabled: showChart),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8 * 3),
                Stopwatch(
                  from: splits?.last,
                  frozen: paused,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .12),
                  child: FittedBox(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<CountdownTimerCubit, CountdownTimer?>(
                        builder: (final context, final ct) =>
                            ScoreCard(score: NumberFormat.decimalPattern().format(splits?.score ?? 0).replaceAll('0', 'O')),
                      ),
                      const SizedBox(width: 4),
                      ...controlls(context, paused: paused),
                      const SizedBox(width: 4),
                      const LockerCard(),
                    ],
                  )),
                ),
                const SizedBox(height: 8 * 4),
              ],
            );
          },
        ),
      );

  List<IconButton> controlls(final BuildContext context, {final bool paused = false}) => [
        paused
            ? IconButton.filledTonal(
                onPressed: () async {
                  final al = AppLocalizations.of(context)!;
                  final auth = context.read<LoginCubit>().state!.auth;
                  await context.read<CountdownTimerCubit>().resume(auth, al, DateTime.now());
                },
                icon: SvgIcon(
                  assetPath: Assets.icons.playCircle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
            : IconButton.filledTonal(
                onPressed: () async {
                  final al = AppLocalizations.of(context)!;
                  final auth = context.read<LoginCubit>().state!.auth;
                  await context.read<CountdownTimerCubit>().pause(auth, al, DateTime.now());
                },
                icon: SvgIcon(
                  assetPath: Assets.icons.stopCircle,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
        IconButton.filledTonal(
          onPressed: _gotoTime(context),
          icon: SvgIcon(
            assetPath: Assets.icons.history,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        // IconButton.filledTonal(
        //   onPressed: _gotoShop(context),
        //   icon: SvgIcon(
        //     assetPath: Assets.icons.checklist,
        //     color: Theme.of(context).colorScheme.onPrimaryContainer,
        //   ),
        // ),
      ];

  void Function() _gotoTime(final BuildContext context) => () => openModal(
        context,
        BlocBuilder<LoginCubit, Profile?>(
          builder: (final context, final u) => Modal(
            title: AppLocalizations.of(context)!.modalTimerEvents,
            child: TimeModal(auth: u?.auth),
          ),
        ),
      );
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    required this.score,
    super.key,
  });

  final String score;

  @override
  Widget build(final BuildContext context) => Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        elevation: 3,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: SvgIcon(
                assetPath: Assets.icons.bolt,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                sizeOffset: 6,
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.only(right: 16, left: 8, top: 8, bottom: 8),
              child: AnimatedCountedUp(
                child: Text(
                  score,
                  key: ValueKey(score),
                  style: fAccent(textStyle: Theme.of(context).textTheme.bodyLarge).copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class Stopwatch extends StatelessWidget {
  const Stopwatch({
    required this.from,
    required this.frozen,
    this.small = false,
    super.key,
  });

  final DateTime? from;
  final bool frozen;
  final bool small;

  @override
  Widget build(final BuildContext context) {
    final tsm = fAccent(
      textStyle: small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall,
    ).copyWith(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    final ts = (small ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.displaySmall)?.copyWith(
      fontWeight: FontWeight.w100,
      color: Theme.of(context).colorScheme.onSecondaryContainer,
    );

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Ticker(small: small, child: ClockHand(ClockHandType.days, from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(small: small, child: ClockHand(ClockHandType.hours, from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(small: small, child: ClockHand(ClockHandType.minutes, from: from, frozen: frozen, style: tsm)),
          Text(':', style: ts),
          Ticker(small: small, child: ClockHand(ClockHandType.seconds, from: from, frozen: frozen, style: tsm)),
        ],
      ),
    );
  }
}

class Ticker extends StatelessWidget {
  const Ticker({
    required this.child,
    this.small = false,
    super.key,
  });

  final Widget child;
  final bool small;

  @override
  Widget build(final BuildContext context) => Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: child,
              ),
            ),
          ],
        ),
      );
}

enum ClockHandType {
  days,
  hours,
  minutes,
  seconds,
}

class ClockHand extends StatefulWidget {
  const ClockHand(
    this.tm, {
    required this.from,
    required this.frozen,
    required this.style,
    super.key,
  });

  final ClockHandType tm;
  final DateTime? from;
  final bool frozen;
  final TextStyle style;

  @override
  State<ClockHand> createState() => _ClockHandState();
}

class _ClockHandState extends State<ClockHand> {
  @override
  Widget build(final BuildContext context) {
    if (!widget.frozen) scheduleRefresh();
    final v = value();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: AnimatedCountedUp(
        child: Text(
          v,
          key: ValueKey<String>(v),
          style: widget.style.copyWith(fontSize: 160),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String value() {
    String v = 'OO';
    if (widget.from != null) {
      final Duration diff = DateTime.now().difference(widget.from!);

      switch (widget.tm) {
        case ClockHandType.days:
          final p = diff.inDays;
          v = p.toString();
        case ClockHandType.hours:
          final p = diff.inHours % 24;
          v = p.toString();
        case ClockHandType.minutes:
          final p = diff.inMinutes % 60;
          v = p.toString();
        case ClockHandType.seconds:
          final p = diff.inSeconds % 60;
          v = p.toString();
      }
    }

    return v.padLeft(2, '0').replaceAll('0', 'O');
  }

  Timer? scheduleRefresh() {
    final Duration timerDuration;
    switch (widget.tm) {
      case ClockHandType.days:
        timerDuration = const Duration(seconds: 1);
      case ClockHandType.hours:
        timerDuration = const Duration(seconds: 1);
      case ClockHandType.minutes:
        timerDuration = const Duration(seconds: 1);
      case ClockHandType.seconds:
        timerDuration = const Duration(milliseconds: 10);
    }

    Timer? t;
    return t = Timer(timerDuration, () {
      if (widget.frozen || !mounted) {
        if (t != null) t.cancel();
        return;
      }

      setState(() {});
    });
  }
}
