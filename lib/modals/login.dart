import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({
    super.key,
  });

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
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
                    Input(title: AppLocalizations.of(context)!.loginEmail, ctrl: cEmail, autocorrect: false),
                    const SizedBox(height: 8),
                    Input(title: AppLocalizations.of(context)!.loginPassword, ctrl: cPwd, autocorrect: false, obscureText: true),
                    if (errorText != '') const SizedBox(height: 8),
                    if (errorText != '')
                      Text(
                        errorText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    Flexible(child: ListView()),
                    FilledButton(
                      onPressed: () async {
                        final n = Navigator.of(context);

                        try {
                          if (n.canPop()) {
                            await context.read<LoginCubit>().signIn(cEmail.text, cPwd.text);
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
                        child: Text(AppLocalizations.of(context)!.loginLogin),
                      ),
                    ),
                  ],
                ),
              ),
            ));
}
