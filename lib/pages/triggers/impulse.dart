import 'package:flutter/material.dart';

class ImpulseSlider extends StatefulWidget {
  const ImpulseSlider({
    required this.title,
    required this.callback,
    super.key,
  });

  final String title;
  final Function(double) callback;

  @override
  State<ImpulseSlider> createState() => _ImpulseSliderState();
}

class _ImpulseSliderState extends State<ImpulseSlider> {
  double impulse = 3;

  @override
  Widget build(final BuildContext context) {
    final t = Theme.of(context);
    return Column(
      children: [
        SliderTheme(
          data: Theme.of(context).sliderTheme.copyWith(
                showValueIndicator: ShowValueIndicator.always,
              ),
          child: Slider(
            value: impulse,
            max: 10,
            divisions: 10,
            label: '${impulse.round()}',
            onChanged: (final double value) {
              setState(() {
                impulse = value;
              });
            },
            onChangeEnd: (final value) => widget.callback(value),
          ),
        ),
        Text(
          widget.title,
          style: t.textTheme.bodySmall!.copyWith(
            color: t.hintColor,
          ),
        ),
      ],
    );
  }
}
