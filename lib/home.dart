import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/pages/clock/main.dart';
import 'package:dependencecoping/pages/meditation/meditation.dart';
import 'package:dependencecoping/pages/triggers/triggers.dart';
import 'package:dependencecoping/paginator.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (final int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: SvgIcon(assetPath: Assets.icons.timer),
            label: AppLocalizations.of(context)!.screenClock,
          ),
          NavigationDestination(
            icon: SvgIcon(assetPath: Assets.icons.mindfulness),
            label: AppLocalizations.of(context)!.screenTriggers,
          ),
          NavigationDestination(
            icon: SvgIcon(assetPath: Assets.icons.relax),
            label: AppLocalizations.of(context)!.screenMeditation,
          ),
        ],
      ),
      body: [
        ClockScreen(setPage: pagginator(context)),
        TriggersScreen(setPage: pagginator(context)),
        const MeditationScreen(),
      ][currentPageIndex],
    );
}
