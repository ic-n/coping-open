import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownManual extends StatelessWidget {
  const MarkdownManual({
    required this.section,
    required this.fragment,
    super.key,
  });

  final String section;
  final String fragment;

  @override
  Widget build(final BuildContext context) => FutureBuilder(
        // ignore: discarded_futures
        future: rootBundle.loadString(AppLocalizations.of(context)!.helpManuals(fragment, section)),
        builder: (final context, final snapshot) =>
            snapshot.connectionState == ConnectionState.done ? MarkdownBody(data: snapshot.requireData) : const Text('[...]'),
      );
}
