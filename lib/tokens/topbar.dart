import 'dart:async';

import 'package:dependencecoping/discord/discord.dart';
import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/tokens/cardrope.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/measurable.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NullTopBar extends StatelessWidget {
  const NullTopBar({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
        elevation: 2,
        child: const SizedBox(
          width: double.infinity,
          height: 4,
        ),
      );
}

class TopBar extends StatefulWidget {
  const TopBar({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool expandMenu = false;

  @override
  Widget build(final BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            body(),
            head(context),
          ],
        ),
      );

  Null Function() goTo(final int pageKey) => () {
        widget.setPage(pageKey);
        setState(() {
          expandMenu = !expandMenu;
        });
      };

  BlocBuilder<LoginCubit, Profile?> head(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
      builder: (final _, final u) => Material(
            color: Theme.of(context).appBarTheme.backgroundColor,
            shadowColor: Theme.of(context).appBarTheme.shadowColor,
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          openModal(
                            context,
                            const HelpModal(),
                          );
                        },
                        icon: SvgIcon(assetPath: Assets.icons.liveHelp),
                      ),
                      FutureBuilder(
                        // ignore: discarded_futures
                        future: discordObtainInvite(),
                        builder: (final context, final snapshot) => Badge(
                          alignment: Alignment.topRight,
                          offset: const Offset(-4, 6),
                          largeSize: 8,
                          padding: EdgeInsets.zero,
                          label: const SizedBox.square(dimension: 8),
                          child: IconButton(
                            onPressed: () {
                              unawaited(launchUrlString(snapshot.data.toString()));
                            },
                            icon: SvgIcon(assetPath: Assets.icons.diversity1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Coping',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w900),
                        ),
                        // TextSpan(
                        //   text: AppLocalizations.of(context)!.hello,
                        //   style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                        //   children: [
                        //     if ((u?.profile?.firstName ?? '') != '')
                        //       TextSpan(
                        //         text: ' ${u?.profile?.firstName ?? ''}',
                        //       ),
                        //   ],
                        // )
                      ]),
                    ),
                  ),
                  Row(
                    children: [
                      Opacity(
                        opacity: 0,
                        child: IconButton(
                          onPressed: () {},
                          icon: SvgIcon(assetPath: Assets.icons.bolt),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            expandMenu = !expandMenu;
                          });
                        },
                        icon: AnimatedRotation(
                          duration: const Duration(milliseconds: 100),
                          turns: expandMenu ? 0.5 : 0,
                          child: SvgIcon(assetPath: Assets.icons.expandMore),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));

  Widget body() => Shrinkable(
        expanded: expandMenu,
        child: CardRope(
          cards: [
            RopedCard(
              children: [
                BlocBuilder<LoginCubit, Profile?>(builder: (final context, final u) {
                  final List<Widget> children = [];

                  if (u == null) {
                    children.add(NavButton(AppLocalizations.of(context)!.screenLogin, onPressed: goTo(0)));
                    children.add(NavButton(AppLocalizations.of(context)!.screenRegister, onPressed: goTo(1)));
                  } else {
                    children.add(NavButton(AppLocalizations.of(context)!.screenProfile, onPressed: goTo(2)));
                    children.add(NavButton(AppLocalizations.of(context)!.screenLogin, onPressed: goTo(0)));
                    children.add(NavButton(AppLocalizations.of(context)!.screenLogout, onPressed: goTo(3)));
                  }

                  return Wrap(
                    runSpacing: 8,
                    children: children,
                  );
                }),
              ],
            ),
            RopedCard(
              children: [
                _themeSettings(),
              ],
            ),
            const SizedBox(
              height: 0,
            ),
          ],
        ),
      );

  Widget _themeSettings() => const ThemeChanger();
}

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => BlocBuilder<ThemeCubit, ThemeState>(
        builder: (final context, final t) => Row(
          children: [
            FilledButton.tonal(
              style: Theme.of(context).filledButtonTheme.style,
              onPressed: () {
                // '!' (NOT) because we just fliped but yet refreshed.
                unawaited(context.read<LoginCubit>().setTheme(t.color.name, isLight: !t.isLightMode()));
                unawaited(context.read<ThemeCubit>().flipBrightness());
              },
              child: SvgIcon(
                assetPath: t.isLightMode() ? Assets.icons.lightMode : Assets.icons.darkMode,
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  t.color.name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                final next = (ColorValue.values.indexOf(t.color) + 1) % (ColorValue.values.length);
                final selected = ColorValue.values[next];
                context.read<ThemeCubit>().setColor(selected);
                unawaited(context.read<LoginCubit>().setTheme(selected.name, isLight: t.isLightMode()));
              },
              child: SvgIcon(assetPath: Assets.icons.palette),
            ),
          ],
        ),
      );
}

class NavButton extends StatelessWidget {
  const NavButton(
    this.page, {
    required this.onPressed,
    super.key,
  });
  final String page;
  final Function() onPressed;

  @override
  Widget build(final BuildContext context) => FilledButton.tonal(
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(page),
        ),
      );
}
