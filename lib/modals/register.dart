import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase/supabase.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({
    super.key,
  });

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  String errorText = '';

  var cEmail = TextEditingController(text: '');
  var cPwd = TextEditingController(text: '');

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
      builder: (final context, final u) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              child: Column(
                children: [
                  Input(title: AppLocalizations.of(context)!.registerEmail, ctrl: cEmail, autocorrect: false),
                  const SizedBox(height: 8),
                  Input(title: AppLocalizations.of(context)!.registerPassword, ctrl: cPwd, autocorrect: false, obscureText: true),
                  Flexible(child: ListView()),
                  FilledButton(
                    onPressed: () async {
                      final n = Navigator.of(context);

                      try {
                        if (n.canPop()) {
                          await context.read<LoginCubit>().signUp(cEmail.text, cPwd.text);
                          n.pop();
                        }
                      } on AuthException catch (error) {
                        setState(() {
                          errorText = error.message;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.registerRegister),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
