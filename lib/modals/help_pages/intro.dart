import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/pages/clock/countdown.dart';
import 'package:dependencecoping/tools/text_asset.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroHelpPage extends StatelessWidget {
  const IntroHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Guy(text: AppLocalizations.of(context)!.helpIntro, face: Assets.guy.neutral),
          Expanded(
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'clock', fragment: 'm0_about'),
                ),
                Handed(
                  computeTop: (final s, final av) => 0,
                  computeLeft: (final s, final av) => 16 + ((s - 32) * av),
                  duration: const Duration(seconds: 15),
                  child: Stopwatch(
                    from: DateTime.now(),
                    frozen: !true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'clock', fragment: 'm1_clock'),
                ),
                Handed(
                  computeTop: (final s, final av) => s - (av * 4),
                  computeLeft: (final s, final av) => s,
                  duration: const Duration(seconds: 1),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScoreCard(score: '9,320'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: MarkdownManual(section: 'clock', fragment: 'm2_score'),
                ),
              ],
            ),
          )
        ],
      );
}
