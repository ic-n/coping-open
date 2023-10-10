import 'dart:async';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/pages/clock/locker.dart';
import 'package:dependencecoping/provider/locker/locker.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tools/text_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LockerHelpPage extends StatefulWidget {
  const LockerHelpPage({
    super.key,
  });

  @override
  State<LockerHelpPage> createState() => _LockerHelpPageState();
}

class _LockerHelpPageState extends State<LockerHelpPage> with SingleTickerProviderStateMixin {
  late final ac = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Guy(text: AppLocalizations.of(context)!.helpLocker, face: Assets.guy.sceptic),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Handed(
                      computeTop: (final s, final av) => s,
                      computeLeft: (final s, final av) => s * av,
                      duration: const Duration(seconds: 10),
                      child: LockerCardMock(
                        state: const Locker(),
                        hours: PageController(),
                        minutes: PageController(),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm1_intro'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(builder: (final context) {
                      final hours = PageController();
                      final minutes = PageController();

                      Timer(
                        const Duration(seconds: 1),
                        () => Timer.periodic(const Duration(seconds: 1), (final t) async {
                          try {
                            await minutes.animateToPage(
                              ((minutes.page! + 1) % 2).toInt(),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceOut,
                            );
                            // ignore: avoid_catches_without_on_clauses
                          } catch (e) {
                            t.cancel();
                          }
                        }),
                      );

                      return Handed(
                        computeTop: (final s, final av) => s - (s / 2) * av,
                        computeLeft: (final s, final av) => s * .65,
                        duration: const Duration(seconds: 2),
                        child: LockerCardMock(
                          state: const Locker(),
                          hours: hours,
                          minutes: minutes,
                        ),
                      );
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(builder: (final context) {
                      final hours = PageController();
                      final minutes = PageController();

                      Timer(
                        const Duration(seconds: 1),
                        () => Timer.periodic(const Duration(seconds: 1), (final t) async {
                          try {
                            await hours.animateToPage(
                              ((hours.page! + 1) % 2).toInt(),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceOut,
                            );
                            // ignore: avoid_catches_without_on_clauses
                          } catch (e) {
                            t.cancel();
                          }
                        }),
                      );

                      return Handed(
                        computeTop: (final s, final av) => s - (s / 2) * av,
                        computeLeft: (final s, final av) => s * .05,
                        duration: const Duration(seconds: 2),
                        child: LockerCardMock(
                          state: const Locker(),
                          hours: hours,
                          minutes: minutes,
                        ),
                      );
                    }),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm2_scroll'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Handed(
                      computeTop: (final s, final av) => s - 8 * av,
                      computeLeft: (final s, final av) => s * .9,
                      duration: const Duration(seconds: 2),
                      child: LockerCardMock(
                        state: const Locker(),
                        hours: PageController(initialPage: 2),
                        minutes: PageController(initialPage: 4),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm3_start'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Handed(
                      computeTop: (final s, final av) => s,
                      computeLeft: (final s, final av) => s * av,
                      duration: const Duration(seconds: 10),
                      child: LockerCardMock(
                        state: Locker(
                          start: DateTime.now(),
                          duration: const Duration(hours: 2, minutes: 30),
                        ),
                        hours: PageController(),
                        minutes: PageController(),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm4_started'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Handed(
                      computeTop: (final s, final av) => s - 8 * av,
                      computeLeft: (final s, final av) => s * .9,
                      duration: const Duration(seconds: 2),
                      child: LockerCardMock(
                        state: Locker(
                          start: DateTime.now(),
                          duration: const Duration(hours: 2, minutes: 30),
                        ),
                        hours: PageController(),
                        minutes: PageController(),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm5_stop'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Handed(
                      noMargin: true,
                      computeTop: (final s, final av) => s * .9,
                      computeLeft: (final s, final av) => (s * .3) + (s * .4 * av),
                      duration: const Duration(seconds: 6),
                      child: Lockpicking(
                        postAnimitationStart: (final lac) {
                          lac.stop();
                          lac.reset();
                          lac.repeat(period: const Duration(seconds: 10), reverse: true);
                          return const LockerMagicCurve();
                        },
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm6_lockpick'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Stack(children: [
                        LockerCardMock(
                          state: const Locker(),
                          hours: PageController(),
                          minutes: PageController(),
                        ),
                        FadeTransition(
                          opacity: ac.drive(CurveTween(curve: Curves.easeOut)),
                          child: LockerCardMock(
                            state: const Locker(positive: true),
                            hours: PageController(),
                            minutes: PageController(),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'locker', fragment: 'm7_check'),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      );
}

class LockerCardMock extends StatelessWidget {
  const LockerCardMock({required this.state, required this.hours, required this.minutes, super.key});

  final Locker state;
  final PageController hours;
  final PageController minutes;

  @override
  Widget build(final BuildContext context) {
    final w = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: state.duration == Duration.zero ? _unlocked(state) : _locked(state),
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      child: state.positive
          ? Badge(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              label: SvgIcon(
                assetPath: Assets.icons.done,
                sizeOffset: 8,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              child: w,
            )
          : w,
    );
  }

  List<Widget> _unlocked(final Locker state) => [
        Row(
          children: [
            ScrollOptions(controller: hours, options: hourOpts),
            const Text(':'),
            ScrollOptions(controller: minutes, options: minuteOpts),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: SvgIcon(assetPath: Assets.icons.lockOpen),
        ),
      ];

  List<Widget> _locked(final Locker state) => [
        TimerClock(start: state.start!, duration: state.duration),
        IconButton(
          onPressed: () {},
          icon: SvgIcon(assetPath: Assets.icons.lock),
        ),
      ];
}

class LockerMagicCurve extends Curve {
  const LockerMagicCurve();

  @override
  double transformInternal(final double t) => (t * 1.25).clamp(0, 1);
}
