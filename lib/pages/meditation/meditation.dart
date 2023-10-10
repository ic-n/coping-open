import 'dart:core';
import 'dart:math';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:funvas/funvas.dart';

class CanvasDrawer extends Funvas {
  CanvasDrawer({
    required this.primary,
    required this.secondary,
    required this.backdrop,
    required this.fullCycleDuration,
    required this.scale,
    required this.slideDist,
    required this.rounds,
    this.muted = false,
  });
  HSLColor primary;
  HSLColor secondary;
  Color backdrop;
  final double fullCycleDuration;
  final double scale;
  final double slideDist;
  final int rounds;
  bool windDown = false;
  double windDownTime = -1;
  final bool muted;

  @override
  void u(double t) {
    if (muted) t += fullCycleDuration;
    if (!muted) t = max(0, t - 1);

    final w = x.width / 2;
    final h = x.height / 2;
    final s = x.width < x.height ? x.width : x.height;
    final pt = (s * scale) / 64;

    if (windDownTime > -1) {
      double cycle = graph(windDownTime);
      cycle = max(0, cycle - (t - windDownTime));
      final slide = slideDist * pt - (cycle * (slideDist * pt));

      _drawCircle(primary, pt, w, h, slide);
      _drawParticles(pt, w, h, cycle, t, slide);

      return;
    }
    if (windDown) {
      windDownTime = t;
    }

    final double cycle = graph(t);
    final slide = slideDist * pt - (cycle * (slideDist * pt));

    _drawParticles(pt, w, h, cycle, t, slide);
    if (!muted) _drawGuideLine(primary, pt, w, h);
    if (!muted) _drawCircle(primary, pt, w, h, slide);
  }

  void _drawParticles(final double pt, final double w, final double h, final double cycle, final double t, final double slide) {
    for (int round = 0; round < rounds; round++) {
      final rCycle = round / rounds;
      final r = (4 * pt) + ((((muted ? 0 : cycle) * 3.85) + 1) * rCycle * 16 * pt) / 3;

      final angleSkew = (13.1 + (t / 31)) * ((round + 1) * 14);

      double alpha = max(0, (min(max((t / fullCycleDuration) - .25, 0), round / rounds) / 2) - 0.05);

      if (windDownTime > -1) {
        alpha = max(0, alpha - (t - windDownTime));
      }

      for (double i = 0; i < 360; i += 360 / (rounds + (round * 4))) {
        final iCycle = (1 + sin((pow(i + 1, 2) * (round + 1)) + t * 2)) / 2;
        final v = iCycle * pt / 2;

        final angle = (i + 1) * (pi / 2) + angleSkew;

        final lr = r + (v * 8);

        final x1 = lr * cos(angle * pi / 180);
        var y1 = lr * sin(angle * pi / 180);
        y1 = y1 - slide;

        final col = (i % 5 != 0 ? primary : secondary).withAlpha(alpha).toColor();

        c.drawCircle(
          Offset(w + x1, h - y1),
          v,
          Paint()..color = Color.alphaBlend(col, backdrop),
        );
      }
    }
  }

  void _drawGuideLine(final HSLColor color, final double pt, final double w, final double h) {
    final pointPaint = Paint();
    pointPaint.color = color.toColor().withAlpha(25);
    pointPaint.strokeCap = StrokeCap.round;
    pointPaint.strokeWidth = pt / 4;
    c.drawLine(
      Offset(w, h),
      Offset(w, h + (slideDist * pt)),
      pointPaint,
    );
  }

  void _drawCircle(final HSLColor color, final double pt, final double w, final double h, final double slide) {
    final circlePaint = Paint();
    circlePaint.color = color.toColor();
    circlePaint.strokeCap = StrokeCap.round;
    circlePaint.strokeWidth = pt / 4;
    c.drawCircle(
      Offset(w, h + slide),
      pt,
      circlePaint,
    );
  }

  double graph(final double t) {
    final x = 1 - ((t % fullCycleDuration) / fullCycleDuration);

    final fnUp = bezFn(x, 3, 0);
    final fnDown = bezFn(x, -1.5, -1);

    final cycle = x < 1 / 3 ? fnUp : fnDown;
    return cycle;
  }

  double bezFn(final double x, final double compression, final double offset) {
    final v = compression * (x + offset);

    final y = pow(v, 2) / (2 * (pow(v, 2) - v) + 1);

    return y;
  }
}

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(builder: (final context, final u) {
        final breathingTime = u?.profile?.breathingTime ?? 6.0;

        final cd = CanvasDrawer(
          backdrop: Theme.of(context).scaffoldBackgroundColor,
          primary: HSLColor.fromColor(Theme.of(context).colorScheme.primary),
          secondary: HSLColor.fromColor(Theme.of(context).colorScheme.tertiary),
          fullCycleDuration: breathingTime,
          scale: 1.3,
          rounds: 12,
          slideDist: 12,
        );
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FunvasContainer(
                funvas: cd,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: InfoCard(
                speed: breathingTime,
                setSpeed: (final s) {
                  Future.delayed(const Duration(seconds: 1), () async {
                    await context.read<LoginCubit>().setBreathingTime(s);
                  });
                },
                changingSpeed: () {
                  cd.windDown = true;
                },
              ),
            )
          ],
        );
      });
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    required this.speed,
    required this.setSpeed,
    required this.changingSpeed,
    super.key,
  });

  final double speed;
  final Function(double) setSpeed;
  final Function() changingSpeed;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  double _speed = 6;
  bool _expandInfo = false;

  @override
  void initState() {
    _speed = widget.speed;
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Column(
        verticalDirection: VerticalDirection.up,
        children: [
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {
                setState(() {
                  _expandInfo = !_expandInfo;
                });
              },
              icon: _expandInfo ? SvgIcon(assetPath: Assets.icons.close) : SvgIcon(assetPath: Assets.icons.expandMore),
            ),
          ),
          Shrinkable(
            expanded: _expandInfo,
            child: body(context),
          ),
          const NullTopBar(),
        ],
      );

  Widget body(final BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.meditationHowToTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ...[
                  AppLocalizations.of(context)!.meditationHowTo1,
                  AppLocalizations.of(context)!.meditationHowTo2,
                  AppLocalizations.of(context)!.meditationHowTo3,
                  AppLocalizations.of(context)!.meditationHowTo4,
                  AppLocalizations.of(context)!.meditationHowTo5,
                  AppLocalizations.of(context)!.meditationHowTo6,
                  AppLocalizations.of(context)!.meditationHowTo7,
                  '${AppLocalizations.of(context)!.meditationHowTo8((_speed / 3 * 1).round())} ${AppLocalizations.of(context)!.meditationHowTo9((_speed / 3 * 2).round())}',
                  AppLocalizations.of(context)!.meditationHowTo10,
                ].map((final e) => Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('— ', style: Theme.of(context).textTheme.bodySmall),
                          Flexible(
                            child: Text(e, style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                  child: Slider(
                    value: _speed > 3 || _speed < 32 ? _speed : 6,
                    min: 3,
                    max: 32,
                    label: '${(_speed / 3 * 2).round()}',
                    onChangeEnd: (final x) {
                      setState(() {
                        _speed = (x * 10).round() / 10;
                        widget.setSpeed(x);
                      });
                    },
                    onChanged: (final x) {
                      setState(() {
                        _speed = (x * 10).round() / 10;
                        widget.changingSpeed();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
