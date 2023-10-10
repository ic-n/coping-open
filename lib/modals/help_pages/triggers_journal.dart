import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_faker.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/pages/triggers/log.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:dependencecoping/tools/text_asset.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TriggersJournalHelpPage extends StatelessWidget {
  const TriggersJournalHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final triggers = randomTexts();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Guy(text: AppLocalizations.of(context)!.helpTriggersJournal, face: Assets.guy.happy),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  TriggerLogCard(TriggerLog(
                    impulse: 6,
                    labels: {'en': triggers[0]},
                    situation: '',
                    thought: '',
                    time: DateTime.now(),
                  )),
                  TriggerLogCard(TriggerLog(
                    impulse: 3,
                    labels: {'en': triggers[1]},
                    situation: '',
                    thought: '',
                    time: DateTime.now(),
                  )),
                ]),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: MarkdownManual(section: 'triggers_journal', fragment: 'm1_list'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
