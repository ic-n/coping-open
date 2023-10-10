import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/modals/help_pages/_modal.dart';
import 'package:dependencecoping/pages/clock/modals/time_manager.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tools/text_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ControlButtonsHelpPage extends StatelessWidget {
  const ControlButtonsHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Guy(text: AppLocalizations.of(context)!.helpButtons, face: Assets.guy.positive),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Center(child: handedControls(context, 1, paused: true)),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'buttons', fragment: 'm1_start'),
                ),
                Center(child: handedControls(context, 1)),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'buttons', fragment: 'm2_stop'),
                ),
                Center(child: handedControls(context, 2.15, paused: true)),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'buttons', fragment: 'm3_history'),
                ),
                ModalContainer(
                  title: AppLocalizations.of(context)!.modalTimerEvents,
                  computeTop: (final s, final av) => s * 1,
                  computeLeft: (final s, final av) => 16 + (s - 32) * av,
                  child: Column(
                    children: [
                      TimerJournalCard(
                        resume: false,
                        dateText: DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now()),
                        onEditPressed: () async {},
                      ),
                      TimerJournalCard(
                        resume: true,
                        dateText: DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now().add(const Duration(hours: -8, minutes: 2, seconds: 8))),
                        onEditPressed: () async {},
                      ),
                      TimerJournalCard(
                        resume: false,
                        dateText: DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now().add(const Duration(hours: -9, minutes: 46, seconds: 17))),
                        onEditPressed: () async {},
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'buttons', fragment: 'm4_history_modal'),
                ),
              ],
            ),
          ),
        ],
      );

  Handed handedControls(final BuildContext context, final double i, {final bool paused = false}) => Handed(
        computeTop: (final s, final av) => s - 4 * av,
        computeLeft: (final s, final av) => (2 * i - 1) * (s / 4),
        duration: const Duration(seconds: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            paused
                ? IconButton.filledTonal(
                    onPressed: () {},
                    icon: SvgIcon(
                      assetPath: Assets.icons.playCircle,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : IconButton.filledTonal(
                    onPressed: () {},
                    icon: SvgIcon(
                      assetPath: Assets.icons.stopCircle,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: SvgIcon(
                assetPath: Assets.icons.history,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      );
}
