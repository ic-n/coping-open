import 'dart:async';

import 'package:dependencecoping/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogoutModal extends StatelessWidget {
  const LogoutModal({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
      builder: (final context, final u) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.clearStorageWarning),
                  Flexible(child: ListView()),
                  FilledButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        unawaited(context.read<LoginCubit>().signOut());
                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(AppLocalizations.of(context)!.clearStorage),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
