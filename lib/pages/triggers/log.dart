import 'package:dependencecoping/pages/triggers/modals/log_event.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TriggerLogCard extends StatelessWidget {
  const TriggerLogCard(
    this.tl, {
    super.key,
  });

  final TriggerLog tl;

  @override
  Widget build(final BuildContext context) {
    final p = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                p.withOpacity(.05),
                p.withOpacity(.05),
                p.withOpacity(0),
                p.withOpacity(0),
              ],
              stops: [0, tl.impulse / 10, tl.impulse / 10, 1],
            ),
          ),
          child: Row(
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  openModal(
                      context,
                      Modal(
                        title: AppLocalizations.of(context)!.modalTriggerLogEvent,
                        child: TriggerLogEventModal(tl: tl),
                      ));
                },
                icon: Text(
                  tl.impulse.toString().replaceAll('0', 'O'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Center(
                  child: Text(
                    tl.labels[Localizations.localeOf(context).languageCode] ?? tl.labels['en'] ?? '[...]',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(tl.time).replaceAll('0', 'O'),
                    style: fAccent(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ).copyWith(fontWeight: FontWeight.w100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
