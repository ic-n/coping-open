import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// void Function() _gotoShop(final BuildContext context) => () => openModal(
//       context,
//       BlocBuilder<LoginCubit, Profile?>(
//         builder: (final context, final u) => Modal(
//           title: AppLocalizations.of(context)!.modalGoals,
//           child: GoalModal(auth: u?.auth),
//         ),
//       ),
//     );

class GoalsList extends StatelessWidget {
  const GoalsList({
    required this.splits, super.key,
  });

  final Splits? splits;

  @override
  Widget build(final BuildContext context) => BlocBuilder<GoalsCubit, Goals?>(builder: (final BuildContext context, final Goals? goals) {
      final gs = (goals?.data ?? []).toList();
      gs.sort((final a, final b) => a.rate.compareTo(b.rate));

      return Column(
        children: gs
            .map((final g) => GoalCard(
                  key: GlobalKey(debugLabel: '${g.id} ${g.iconName}'),
                  from: splits?.last ?? DateTime.now(),
                  iconName: g.iconName,
                  titles: g.titles,
                  descriptions: g.descriptions,
                  rate: g.rate,
                ))
            .toList(),
      );
    });
}

class GoalCard extends StatefulWidget {
  const GoalCard({
    required this.from,
    required this.iconName,
    required this.titles,
    required this.descriptions,
    required this.rate,
    super.key,
  });

  final DateTime from;
  final String iconName;
  final Map<String, String> titles;
  final Map<String, String> descriptions;
  final Duration rate;

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool expanded = false;

  @override
  Widget build(final BuildContext context) {
    final double value = DateTime.now().difference(widget.from).inSeconds.toDouble() / widget.rate.inSeconds.toDouble();
    final bool finished = value > 1 ? true : false;
    final segments = widget.rate.inDays.clamp(1, 7 * 4);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: finished
            ? _desc(context, finished, value)
            : Column(
                children: [
                  _desc(context, finished, value),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).dividerColor.withOpacity(.2),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SvgIcon(
                              assetPath: 'assets/icons/${widget.iconName}.svg',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Flexible(
                            child: Meter(
                              value,
                              segments: segments,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _desc(final BuildContext context, final bool finished, final double value) {
    String description = widget.descriptions['en'] ?? widget.descriptions['0'] ?? widget.descriptions['0.0'] ?? '[...]';
    for (final d in widget.descriptions.entries) {
      if (d.key == Localizations.localeOf(context).languageCode) description = d.value;
    }

    String title = widget.titles['en'] ?? widget.titles['0'] ?? widget.titles['0.0'] ?? '[...]';
    for (final t in widget.titles.entries) {
      if (t.key == Localizations.localeOf(context).languageCode) title = t.value;
    }

    final c = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withOpacity(.4),
      Theme.of(context).colorScheme.surface.withOpacity(.6),
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => expanded = !expanded),
          child: Card(
            margin: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (finished)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(800),
                        color: c,
                      ),
                      child: SvgIcon(
                        assetPath: Assets.icons.done,
                        sizeOffset: 8,
                      ),
                    ),
                  ),
                if (finished)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(800),
                        color: c,
                      ),
                      child: SvgIcon(
                        assetPath: 'assets/icons/${widget.iconName}.svg',
                        sizeOffset: 8,
                      ),
                    ),
                  ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Expanded(child: SizedBox()),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 100),
                  turns: expanded ? 0.5 : 0,
                  child: SvgIcon(assetPath: Assets.icons.expandMore),
                )
              ],
            ),
          ),
        ),
        Shrinkable(
          expanded: expanded,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class Meter extends StatelessWidget {
  const Meter(
    this.value, {
    this.segments = 10,
    super.key,
  });

  final double value;
  final int segments;

  @override
  Widget build(final BuildContext context) {
    final List<Widget> c = [];

    for (var i = 0; i < segments; i++) {
      c.add(
        Flexible(
          child: Container(
            alignment: Alignment.centerRight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(1),
            child: LinearProgressIndicator(
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
              color: Theme.of(context).colorScheme.primary.withOpacity(.5),
              value: ((value * segments) - i).clamp(0, 1),
            ),
          ),
        ),
      );
    }

    return Row(
      children: c,
    );
  }
}
