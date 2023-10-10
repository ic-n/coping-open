import 'package:dependencecoping/pages/clock/countdown.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          TopBar(setPage: setPage),
          const Countdown(),
        ],
      );
}

class Countdown extends StatefulWidget {
  const Countdown({
    super.key,
  });

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  bool debug = false;

  @override
  Widget build(final BuildContext context) => const Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CountdownDisplay(),
        ),
      );
}
