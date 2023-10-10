import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetsChart extends StatelessWidget {
  const ResetsChart({required this.enabled, super.key});

  final bool enabled;

  @override
  Widget build(final BuildContext context) => !enabled
      ? const SizedBox(width: double.infinity)
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<CountdownTimerCubit, CountdownTimer?>(builder: (final context, final ct) {
            final List<BarChartGroupData> data = [];

            final List<CountdownEvent> events = ct?.getEvents() ?? [];

            if (events.isEmpty) {
              return const SizedBox(width: double.infinity);
            }

            int i = 10;
            double maxY = 0;
            DateTime? lastReset;
            DateTime? lastResume;

            for (final event in events) {
              if (lastReset != null && lastResume != null && !event.resume) {
                // 1- last reset
                // 2- last resume
                // 3- current reset

                final off = lastReset.difference(lastResume).inMinutes.toDouble().abs();
                final on = lastResume.difference(event.time).inMinutes.toDouble().abs();

                final y = off + on;
                if (y == 0) continue;

                data.add(BarChartGroupData(x: i, barRods: [
                  BarChartRodData(
                      toY: y,
                      width: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      rodStackItems: [
                        BarChartRodStackItem(0, off * 1, Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(.5)),
                        // BarChartRodStackItem(off, on, Colors.green, BorderSide(color: Colors.green)),
                      ]),
                ]));

                if (y > maxY) maxY = y;
                i--;
                if (i < 0) {
                  break;
                }
              }

              if (event.resume) {
                lastResume = event.time;
              } else {
                lastReset = event.time;
              }
            }

            return Stack(
              children: <Widget>[
                BarChart(
                  BarChartData(
                    gridData: const FlGridData(
                      show: false,
                    ),
                    titlesData: const FlTitlesData(
                      rightTitles: AxisTitles(),
                      topTitles: AxisTitles(),
                      bottomTitles: AxisTitles(),
                      leftTitles: AxisTitles(),
                    ),
                    borderData: FlBorderData(show: false),
                    // minX: minX,
                    // maxX: 0,
                    minY: 0,
                    maxY: maxY * 1.5,
                    barGroups: data,
                  ),
                ),
              ],
            );
          }),
        );
}
