import 'package:dependencecoping/modals/login.dart';
import 'package:dependencecoping/modals/logout.dart';
import 'package:dependencecoping/modals/profile.dart';
import 'package:dependencecoping/modals/register.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Function(int) pagginator(final BuildContext context) => (final int page) {
      openModal(
          context,
          [
            Modal(
              title: AppLocalizations.of(context)!.screenLogin,
              child: const LoginModal(),
            ),
            Modal(
              title: AppLocalizations.of(context)!.screenRegister,
              child: const RegisterModal(),
            ),
            Modal(
              title: AppLocalizations.of(context)!.screenProfile,
              child: const ProfileModal(),
            ),
            Modal(
              title: AppLocalizations.of(context)!.screenLogout,
              child: const LogoutModal(),
            ),
          ][page]);
    };
