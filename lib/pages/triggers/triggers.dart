import 'dart:async';

import 'package:dependencecoping/pages/triggers/list.dart';
import 'package:dependencecoping/pages/triggers/log.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/provider/trigger/trigger.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TriggersScreen extends StatelessWidget {
  const TriggersScreen({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBar(setPage: setPage),
          Expanded(
            child: BlocBuilder<TriggersCubit, Triggers?>(
              builder: (final context, final ts) => ListView(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      AppLocalizations.of(context)!.triggerPersonalTriggers,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const TriggerList(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      AppLocalizations.of(context)!.triggerDiscoverTriggers,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const ComunityFolder(),
                  if ((ts?.log ?? []).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        AppLocalizations.of(context)!.triggerTriggerLog,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: ts?.log.map(TriggerLogCard.new).toList() ?? [],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class ComunityFolder extends StatelessWidget {
  const ComunityFolder({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<LoginCubit, Profile?>(
            builder: (final context, final p) => BlocBuilder<StaticCubit, StaticRecords?>(
                  builder: (final context, final s) {
                    final List<Widget> children = [];

                    if (s != null) {
                      children.addAll(
                        s.triggers.map(
                          (final t) => FilledButton.tonal(
                            style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
                            ),
                            onPressed: () {
                              if (p != null) unawaited(context.read<TriggersCubit>().toggle(p.auth, t));
                            },
                            child: Text(t.labels[Localizations.localeOf(context).languageCode] ?? t.labels['en'] ?? '[...]'),
                          ),
                        ),
                      );
                    }

                    return Wrap(
                      runSpacing: 4,
                      spacing: 4,
                      children: children,
                    );
                  },
                )),
      );
}
