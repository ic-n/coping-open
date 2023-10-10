import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dependencecoping/auth/auth.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/storage/local.dart';
import 'package:dependencecoping/storage/locker.dart';
import 'package:dependencecoping/storage/profiles.dart';
import 'package:dependencecoping/storage/reset_log.dart';
import 'package:dependencecoping/storage/static.dart';
import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xid/xid.dart';

enum LoadingProgress { notStarted, started, done }

mixin AssetsInitializer<T extends StatefulWidget> on State<T> {
  LoadingProgress loadingState = LoadingProgress.notStarted;
  bool initOK = false;

  User? user;
  ProfileRecord? profile;
  List<CountdownReset>? resets;
  DateTime? lockerStart;
  Duration? lockerDuration;
  List<Goal>? goals;
  List<Trigger>? triggers;
  List<TriggerLog>? triggersLog;
  StaticRecords statics = StaticRecords(
    goals: [],
    triggers: [],
  );

  @override
  void initState() {
    super.initState();
  }

  Future<String> localText(final String name) => DefaultAssetBundle.of(context).loadString(name);

  bool tryLock() {
    log('trying to lock: state $loadingState', name: 'tools.Assets');
    sleep(const Duration(seconds: 1));

    if (loadingState == LoadingProgress.notStarted) {
      setState(() {
        loadingState = LoadingProgress.started;
      });

      return true;
    }

    return false;
  }

  Future<void> reset(final Function() onEnd) async {
    setState(() {
      loadingState = LoadingProgress.started;
    });

    await _load(onEnd);
  }

  Future<void> init(final Function() onEnd) async {
    setState(() {
      initOK = false;
    });

    await _load(onEnd);

    setState(() {
      initOK = true;
    });
  }

  Future<void> _load(final Function() onEnd) async {
    final userData = await restoreAuthInfo();
    setState(() {
      user = userData;
    });

    if (user == null) {
      final email = 'user-${Xid()}@coping.new';
      final password = Xid().toString();
      await storeCredentials(email, password);

      final auth = await suparegister(email, password);
      if (auth == null) {
        return;
      }

      await storeAuthInfo(auth);
      setState(() {
        user = auth;
      });
    }

    final List<Future> waitGroup = [];

    final profileFuture = getProfile(user!);
    waitGroup.add(profileFuture);

    final staticGoalsFuture = getStaticGoals(user!);
    waitGroup.add(staticGoalsFuture);

    final staticTriggersFuture = getStaticTriggers(user!);
    waitGroup.add(staticTriggersFuture);

    final resetsFuture = getCountdownResets(user!, 'smoking');
    waitGroup.add(resetsFuture);

    final goalsFuture = getGoals(user!);
    waitGroup.add(goalsFuture);

    final triggersFuture = getTriggers(user!);
    waitGroup.add(triggersFuture);

    final triggersLogFuture = getTriggersLog(user!, 'smoking');
    waitGroup.add(triggersLogFuture);

    final lockerSets = getLockerSets(user!);
    waitGroup.add(lockerSets);

    await Future.wait(waitGroup, eagerError: true);

    final vProfile = await profileFuture;
    final vStaticsGoals = await staticGoalsFuture;
    final vStaticsTriggers = await staticTriggersFuture;
    final vResets = await resetsFuture;
    final vGoals = await goalsFuture;
    final vTriggers = await triggersFuture;
    final vTriggersLog = await triggersLogFuture;

    final vLockerSets = await lockerSets;
    vLockerSets.sort((final a, final b) => b.compareTo(a));
    final LockerSet? vLockerSet = vLockerSets.isEmpty ? null : vLockerSets[0];

    setState(() {
      profile = vProfile;
      statics.goals = vStaticsGoals;
      statics.triggers = vStaticsTriggers;
      resets = vResets;
      goals = vGoals;
      triggers = vTriggers;
      triggersLog = vTriggersLog;
      lockerStart = vLockerSet?.start;
      lockerDuration = vLockerSet?.end.difference(vLockerSet.start) ?? Duration.zero;

      loadingState = LoadingProgress.done;
    });

    onEnd();
  }
}
