import 'dart:async';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/storage/local.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileModal extends StatelessWidget {
  const ProfileModal({super.key});

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
      builder: (final context, final u) => ProfileModalContent(
            firstName: u?.profile?.firstName ?? '',
            secondName: u?.profile?.secondName ?? '',
            addictionLabel: u?.profile?.addictionLabel ?? '',
          ));
}

class ProfileModalContent extends StatefulWidget {
  const ProfileModalContent({
    required this.firstName,
    required this.secondName,
    required this.addictionLabel,
    super.key,
  });

  final String firstName;
  final String secondName;
  final String addictionLabel;

  @override
  State<ProfileModalContent> createState() => _ProfileModalContentState();
}

class _ProfileModalContentState extends State<ProfileModalContent> {
  late final cFirstName = TextEditingController(text: widget.firstName);
  late final cSecondName = TextEditingController(text: widget.secondName);
  late final cAddictionLabel = TextEditingController(text: widget.addictionLabel);

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                // ignore: discarded_futures
                future: restoreCredentials(),
                builder: (final context, final snapshot) =>
                    snapshot.data != null && snapshot.data!.isNotNull() ? CredentialsRemider(cred: snapshot.data!) : const SizedBox(),
              ),
              const SizedBox(height: 8),
              Input(title: AppLocalizations.of(context)!.profileFirstName, ctrl: cFirstName, autocorrect: true),
              const SizedBox(height: 8),
              Input(title: AppLocalizations.of(context)!.profileSecondName, ctrl: cSecondName, autocorrect: true),
              const SizedBox(height: 8),
              Input(title: AppLocalizations.of(context)!.profileAddictionLabel, ctrl: cAddictionLabel, autocorrect: true),
              Flexible(child: ListView()),
              Center(
                child: FilledButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      unawaited(context.read<LoginCubit>().saveProfile(
                            cFirstName.text,
                            cSecondName.text,
                            cAddictionLabel.text,
                          ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(AppLocalizations.of(context)!.profileSave),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class CredentialsRemider extends StatelessWidget {
  const CredentialsRemider({
    required this.cred,
    super.key,
  });

  final Credentials cred;

  @override
  Widget build(final BuildContext context) => Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.loginEmail,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Copier(title: 'user-•••••@coping.new', content: cred.email),
                  ],
                ),
              ),
              Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(.2))))),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.loginPassword,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Copier(title: '•••••••••••••••', content: cred.password),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class Copier extends StatelessWidget {
  Copier({
    required this.title,
    required this.content,
    super.key,
  });

  final String title;
  final String? content;
  late final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  @override
  Widget build(final BuildContext context) => Tooltip(
        key: tooltipkey,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        message: AppLocalizations.of(context)!.copied,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          color: Theme.of(context).colorScheme.tertiary.withOpacity(.9),
        ),
        triggerMode: TooltipTriggerMode.manual,
        showDuration: const Duration(milliseconds: 1200),
        child: TextButton.icon(
          onPressed: () {
            tooltipkey.currentState?.ensureTooltipVisible();

            if (content != null) unawaited(Clipboard.setData(ClipboardData(text: content!)));
          },
          icon: Text(
            title,
          ),
          label: Opacity(
            opacity: .5,
            child: SvgIcon(
              assetPath: Assets.icons.contentCopy,
              sizeOffset: 8,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
}
