import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/trigger/trigger.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PersonalTriggerFormModal extends StatefulWidget {
  const PersonalTriggerFormModal({
    super.key,
  });

  @override
  State<PersonalTriggerFormModal> createState() => _PersonalTriggerFormModalState();
}

class _PersonalTriggerFormModalState extends State<PersonalTriggerFormModal> {
  var cLabel = TextEditingController(text: '');

  @override
  Widget build(final BuildContext context) {
    final navigator = Navigator.of(context);

    return BlocBuilder<LoginCubit, Profile?>(builder: (final context, final u) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: AppLocalizations.of(context)!.triggerPersonalLabel, ctrl: cLabel, autocorrect: true),
              const SizedBox(height: 8),
              Flexible(child: ListView()),
              FilledButton(
                onPressed: () async {
                  await context.read<TriggersCubit>().addPersonal(u!.auth, cLabel.value.text);
                  if (navigator.canPop()) navigator.pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.triggerPersonalAddTrigger),
                ),
              ),
            ],
          ),
        ),
      ));
  }
}
