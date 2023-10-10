import 'package:flutter/material.dart';

class Measurable extends StatefulWidget {
  const Measurable({
    required this.child,
    this.reportWidth,
    this.reportHeight,
    super.key,
  });

  final Function(double)? reportHeight;
  final Function(double)? reportWidth;
  final Widget child;

  @override
  State<Measurable> createState() => _MeasurableState();
}

class _MeasurableState extends State<Measurable> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      final rb = _key.currentContext!.findRenderObject()! as RenderBox;
      widget.reportWidth?.call(rb.size.width);
      widget.reportHeight?.call(rb.size.height);
    });
  }

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        reverse: true,
        child: Container(key: _key, child: widget.child),
      );
}

class Shrinkable extends StatefulWidget {
  const Shrinkable({
    required this.child,
    required this.expanded,
    super.key,
    this.duration = const Duration(milliseconds: 200),
  });

  final Widget child;
  final bool expanded;
  final Duration duration;

  @override
  State<Shrinkable> createState() => _ShrinkableState();
}

class _ShrinkableState extends State<Shrinkable> {
  double size = 0;

  @override
  Widget build(final BuildContext context) => AnimatedContainer(
        duration: widget.duration,
        height: widget.expanded ? size : 0,
        child: Measurable(
          reportHeight: (final h) => setState(() => size = h),
          child: widget.child,
        ),
      );
}
