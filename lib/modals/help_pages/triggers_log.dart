import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_faker.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/modals/help_pages/_modal.dart';
import 'package:dependencecoping/modals/help_pages/triggers.dart';
import 'package:dependencecoping/pages/triggers/impulse.dart';
import 'package:dependencecoping/pages/triggers/list.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:dependencecoping/tools/text_asset.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TriggersLogHelpPage extends StatelessWidget {
  const TriggersLogHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final triggers = randomTexts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Guy(text: AppLocalizations.of(context)!.helpTriggersLog, face: Assets.guy.deceptive),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Handed(
                duration: const Duration(seconds: 3),
                computeLeft: (final s, final av) => s * .8,
                computeTop: (final s, final av) => s - (8 * av),
                child: Wrap(
                  children: [
                    TriggerBadge(tertiary: true, text: triggers[0]),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: MarkdownManual(section: 'triggers_log', fragment: 'm1_button'),
              ),
              ModalContainer(
                title: AppLocalizations.of(context)!.modalLogTrigger,
                child: Column(
                  children: [
                    HighText(text: triggers[0]),
                    Handed(
                      duration: const Duration(seconds: 5),
                      computeLeft: (final s, final av) => s * .05 + 48 * av,
                      computeTop: (final s, final av) => s * .1,
                      noMargin: true,
                      child: Input(title: AppLocalizations.of(context)!.personalTriggerSituation, ctrl: TextEditingController(), autocorrect: true),
                    ),
                    const SizedBox(height: 4),
                    Input(title: AppLocalizations.of(context)!.personalTriggerThought, ctrl: TextEditingController(), autocorrect: true),
                    const SizedBox(height: 8 * 2),
                    ImpulseSlider(
                      title: AppLocalizations.of(context)!.personalTriggerImpulse,
                      callback: (final i) {},
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: MarkdownManual(section: 'triggers_log', fragment: 'm2_situation'),
              ),
              ModalContainer(
                title: AppLocalizations.of(context)!.modalLogTrigger,
                child: Column(
                  children: [
                    HighText(text: triggers[0]),
                    Input(
                        title: AppLocalizations.of(context)!.personalTriggerSituation,
                        ctrl: TextEditingController(text: triggers[1]),
                        autocorrect: true),
                    const SizedBox(height: 4),
                    Handed(
                      duration: const Duration(seconds: 5),
                      computeLeft: (final s, final av) => s * .05 + 48 * av,
                      computeTop: (final s, final av) => s * .1,
                      noMargin: true,
                      child: Input(title: AppLocalizations.of(context)!.personalTriggerThought, ctrl: TextEditingController(), autocorrect: true),
                    ),
                    const SizedBox(height: 8 * 2),
                    ImpulseSlider(
                      title: AppLocalizations.of(context)!.personalTriggerImpulse,
                      callback: (final i) {},
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: MarkdownManual(section: 'triggers_log', fragment: 'm3_ct'),
              ),
              ModalContainer(
                title: AppLocalizations.of(context)!.modalLogTrigger,
                child: Column(
                  children: [
                    HighText(text: triggers[0]),
                    Input(
                        title: AppLocalizations.of(context)!.personalTriggerSituation,
                        ctrl: TextEditingController(text: triggers[1]),
                        autocorrect: true),
                    const SizedBox(height: 4),
                    Input(
                        title: AppLocalizations.of(context)!.personalTriggerThought,
                        ctrl: TextEditingController(text: triggers[2]),
                        autocorrect: true),
                    const SizedBox(height: 8 * 2),
                    Handed(
                      duration: const Duration(seconds: 15),
                      computeLeft: (final s, final av) => s * av,
                      computeTop: (final s, final av) => s * .55,
                      noMargin: true,
                      child: ImpulseSlider(
                        title: AppLocalizations.of(context)!.personalTriggerImpulse,
                        callback: (final i) {},
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: MarkdownManual(section: 'triggers_log', fragment: 'm4_impulse'),
              ),
              ModalContainer(
                title: AppLocalizations.of(context)!.modalLogTrigger,
                child: Column(
                  children: [
                    HighText(text: triggers[0]),
                    Input(
                        title: AppLocalizations.of(context)!.personalTriggerSituation,
                        ctrl: TextEditingController(text: triggers[1]),
                        autocorrect: true),
                    const SizedBox(height: 4),
                    Input(
                        title: AppLocalizations.of(context)!.personalTriggerThought,
                        ctrl: TextEditingController(text: triggers[2]),
                        autocorrect: true),
                    const SizedBox(height: 8 * 2),
                    ImpulseSlider(
                      title: AppLocalizations.of(context)!.personalTriggerImpulse,
                      callback: (final i) {},
                    ),
                    const SizedBox(height: 8 * 2),
                    Handed(
                      duration: const Duration(seconds: 3),
                      computeLeft: (final s, final av) => s * .8,
                      computeTop: (final s, final av) => s - (8 * av) - 8,
                      noMargin: true,
                      child: FilledButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(AppLocalizations.of(context)!.personalTriggerSubmit),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: MarkdownManual(section: 'triggers_log', fragment: 'm5_save'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
