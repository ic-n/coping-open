import 'dart:async';

import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalModal extends StatefulWidget {
  const GoalModal({
    super.key,
    this.auth,
  });

  final User? auth;

  @override
  State<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends State<GoalModal> {
  List<Goal> goals = [];

  @override
  void initState() {
    final settings = BlocProvider.of<GoalsCubit>(context);
    if (settings.state != null) goals.addAll(settings.state!.data);
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => BlocBuilder<StaticCubit, StaticRecords?>(builder: (final context, final staticRec) {
        final List<Widget> widgets = [];
        final sortedGoals = [...staticRec!.goals];
        sortedGoals.sort((final g1, final g2) => g1.rate.compareTo(g2.rate));
        widgets.addAll(sortedGoals.map((final g) => _togglableGoal(context, g)));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Flexible(
              child: ListView(
                children: widgets,
              ),
            ),
            FilledButton(
                onPressed: () {
                  if (Navigator.of(context).canPop() && widget.auth != null) {
                    unawaited(context.read<GoalsCubit>().set(widget.auth!, Goals(goals)));
                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context)!.goalsSave)),
          ]),
        );
      });

  Widget _togglableGoal(final BuildContext context, final Goal g) {
    String title = g.titles['en']!;
    for (final t in g.titles.entries) {
      if (t.key == Localizations.localeOf(context).languageCode) title = t.value;
    }

    final onChanged = _toggle(g);
    final currentValue = goals.where((final element) => element.id == g.id).isNotEmpty;

    final goalIconPath = 'assets/icons/${g.iconName}.svg';

    return GoalToggleCard(currentValue: currentValue, onChanged: onChanged, title: title, goalIconPath: goalIconPath);
  }

  Null Function({bool? checkState}) _toggle(final Goal g) => ({final bool? checkState}) {
        if (checkState == null) {
          return;
        }

        if (checkState) {
          setState(() {
            goals.add(g);
          });
          return;
        }

        setState(() {
          goals.removeWhere((final element) => element.id == g.id);
        });
      };

  Column divider(final BuildContext context, final String name) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      );
}

class GoalToggleCard extends StatelessWidget {
  const GoalToggleCard({
    required this.title,
    required this.goalIconPath,
    required this.currentValue,
    this.onChanged,
    super.key,
  });

  final bool currentValue;
  final Null Function({bool? checkState})? onChanged;
  final String title;
  final String goalIconPath;

  @override
  Widget build(final BuildContext context) => Card(
        child: Row(
          children: [
            Checkbox(
              value: currentValue,
              onChanged: (final v) => onChanged?.call(checkState: v),
            ),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SvgIcon(
                assetPath: goalIconPath,
                color: Theme.of(context).colorScheme.primary.withOpacity(.5),
              ),
            ),
          ],
        ),
      );
}
