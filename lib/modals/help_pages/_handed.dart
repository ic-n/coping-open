import 'dart:math';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Handed extends StatefulWidget {
  const Handed({
    required this.computeTop,
    required this.computeLeft,
    required this.duration,
    required this.child,
    this.noMargin = false,
    super.key,
  });

  final double Function(double s, double av) computeTop;
  final double Function(double s, double av) computeLeft;
  final Duration duration;
  final bool noMargin;
  final Widget child;

  @override
  State<Handed> createState() => _HandedState();
}

class _HandedState extends State<Handed> with TickerProviderStateMixin {
  double childWidth = 10;
  double childHeight = 10;

  late final _c = AnimationController(
    duration: widget.duration,
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _c.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnimatedBuilder(
        animation: _c,
        child: _content(context),
        builder: (final context, final child) => _content(context),
      );

  Widget _content(final BuildContext context) => LayoutBuilder(
        builder: (final context, final c) {
          final av = (1 - (_c.value * 2)).abs();

          final t = widget.computeTop(childHeight, av);
          final l = widget.computeLeft(childWidth, av);

          final s = (MediaQuery.of(context).size.width / 8).roundToDouble();

          final topOffsetPercentage = t / childHeight;
          final leftOffsetPercentage = l / childWidth;
          final r = (topOffsetPercentage < .5 ? pi + (pi * (leftOffsetPercentage - .5) / 4) : -(pi * (leftOffsetPercentage - .5) / 4));

          final double m = widget.noMargin ? 0 : 16;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.all(m),
                child: Measurable(
                  reportHeight: (final h) {
                    setState(() => childHeight = h);
                  },
                  reportWidth: (final w) {
                    setState(() => childWidth = w);
                  },
                  child: widget.child,
                ),
              ),
              Positioned(
                top: m + t - (s / 2),
                left: m + l - (s / 2),
                child: Container(
                  width: s,
                  height: s,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiaryContainer,
                        Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.5),
                        Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0),
                      ],
                      stops: const [0.2, 0.6, 1],
                    ),
                    borderRadius: BorderRadius.circular(s),
                  ),
                ),
              ),
              Positioned(
                top: m + t - (s / 4),
                left: m + l - (s / 4),
                child: Transform.rotate(
                  angle: r,
                  child: SvgPicture.asset(
                    Assets.guy.hand,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onTertiaryContainer,
                      BlendMode.srcATop,
                    ),
                    width: s / 2,
                    height: s / 2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                  ),
                ),
              ),
            ],
          );
        },
      );
}
