import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_faker.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/modals/help_pages/_modal.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:dependencecoping/tools/text_asset.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TriggersHelpPage extends StatelessWidget {
  const TriggersHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Guy(text: AppLocalizations.of(context)!.helpTriggersJournal, face: Assets.guy.smart),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Handed(
                    computeTop: (final s, final av) => s * .6,
                    computeLeft: (final s, final av) => 16 + ((s - 32) * av),
                    duration: const Duration(seconds: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Text(
                            AppLocalizations.of(context)!.triggerPersonalTriggers,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Wrap(
                          runSpacing: 4,
                          spacing: 4,
                          children: getRandomButtons(context, withPlus: true, tertiary: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'triggers', fragment: 'm1_pt'),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Handed(
                    computeTop: (final s, final av) => s * .6,
                    computeLeft: (final s, final av) => 16 + ((s - 32) * av),
                    duration: const Duration(seconds: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Text(
                            AppLocalizations.of(context)!.triggerDiscoverTriggers,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Wrap(
                          runSpacing: 4,
                          spacing: 4,
                          children: getRandomButtons(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'triggers', fragment: 'm2_dt'),
                ),
                Wrap(
                  children: [
                    Handed(
                      computeLeft: (final s, final av) => s - 8,
                      computeTop: (final s, final av) => s - (8 * av),
                      duration: const Duration(seconds: 3),
                      child: IconButton.filledTonal(
                        style: const ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
                        ),
                        onPressed: () {},
                        icon: SvgIcon(
                          assetPath: Assets.icons.add,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'triggers', fragment: 'm3_plus'),
                ),
                ModalContainer(
                  title: AppLocalizations.of(context)!.modalAddPersonalTrigger,
                  child: Column(
                    children: [
                      Input(title: AppLocalizations.of(context)!.triggerPersonalLabel, ctrl: TextEditingController(), autocorrect: true),
                      const SizedBox(height: 8),
                      Handed(
                        computeLeft: (final s, final av) => s * .7,
                        computeTop: (final s, final av) => s - (8 * av) - 8,
                        duration: const Duration(seconds: 3),
                        noMargin: true,
                        child: FilledButton(
                          onPressed: () async {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.triggerPersonalAddTrigger),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'triggers', fragment: 'm4_add'),
                ),
              ],
            ),
          )
        ],
      );

  List<Widget> getRandomButtons(final BuildContext context, {final bool withPlus = false, final bool tertiary = false}) {
    final List<Widget> list = [];
    randomTexts().map((final e) => TriggerBadge(tertiary: tertiary, text: e)).forEach(list.add);
    if (withPlus) {
      list.add(
        IconButton.filledTonal(
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
          ),
          onPressed: () {},
          icon: SvgIcon(
            assetPath: Assets.icons.add,
          ),
        ),
      );
    }

    return list;
  }
}

class TriggerBadge extends StatelessWidget {
  const TriggerBadge({
    required this.text,
    required this.tertiary,
    super.key,
  });

  final String text;
  final bool tertiary;

  @override
  Widget build(final BuildContext context) => FilledButton.tonal(
        style: ButtonStyle(
          backgroundColor: tertiary ? MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiaryContainer) : null,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
        ),
        onPressed: () {},
        child: Text(text),
      );
}
