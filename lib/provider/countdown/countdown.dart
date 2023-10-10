import 'package:dependencecoping/notifications.dart';
import 'package:dependencecoping/storage/reset_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownTimer {
  CountdownTimer({
    required this.resets,
    required this.resumed,
    required this.paused,
  });

  List<CountdownReset> resets;
  DateTime? resumed;
  DateTime? paused;

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals

  List<CountdownReset> sortedCopy() {
    final r = [...resets];

    r.sort((final a, final b) => a.compareTo(b));

    return r;
  }

  Splits splits() {
    final resets = sortedCopy();

    int score = 0;

    if (resets.isNotEmpty) {
      var total = Duration.zero;

      for (final r in resets.reversed) {
        final d = (r.resumeTime ?? DateTime.now()).difference(r.resetTime);
        total += d;
      }

      score = (total.inSeconds / 60).round();
    }

    final DateTime last;
    if (resets.lastOrNull?.resumeTime == null) {
      last = DateTime.now();
    } else {
      last = resets.last.resumeTime!;
    }

    return Splits(
      DateTime(last.year, last.month, last.day, last.hour, last.minute, last.second),
      score,
    );
  }

  List<CountdownEvent> getEvents() {
    final List<CountdownEvent> events = [];

    final r = sortedCopy();

    for (final element in r.reversed) {
      if (element.resumeTime != null) events.add(CountdownEvent(id: element.id, resume: true, time: element.resumeTime!));
      events.add(CountdownEvent(id: element.id, resume: false, time: element.resetTime));
    }

    events.sort((final a, final b) => a.time.compareTo(b.time));

    return events;
  }
}

class Splits {
  const Splits(this.last, this.score);

  final DateTime? last;
  final int score;
}

class CountdownEvent {
  const CountdownEvent({
    required this.id,
    required this.resume,
    required this.time,
  });

  final int id;
  final bool resume;
  final DateTime time;

  @override
  String toString() => '$resume - $time';
}

class CountdownTimerCubit extends Cubit<CountdownTimer?> {
  CountdownTimerCubit() : super(null);

  Future<void> resume(final User auth, final AppLocalizations al, final DateTime dt) async {
    if (state == null) return;

    final id = await logCountdownResume(auth, 'smoking', dt);

    final resets = state!.sortedCopy();
    if (resets.isEmpty) {
      resets.add(CountdownReset(
        id: id,
        resetTime: state?.paused ?? DateTime.now(),
        resumeTime: dt,
      ));
    } else {
      resets.last = CountdownReset(
        id: id,
        resetTime: resets.last.resetTime,
        resumeTime: dt,
      );
    }

    await startNotifications(al);

    emit(CountdownTimer(
      resumed: dt,
      paused: null,
      resets: resets,
    ));
  }

  Future<void> pause(final User auth, final AppLocalizations al, final DateTime dt) async {
    if (state == null) return;

    final resets = state!.sortedCopy();

    final id = await logCountdownReset(auth, 'smoking', dt);
    resets.add(CountdownReset(
      id: id,
      resetTime: dt,
      resumeTime: null,
    ));

    await stopNotifications(al);

    emit(CountdownTimer(
      resumed: null,
      paused: dt,
      resets: [...resets],
    ));
  }

  Future<void> editReset(final User user, final int id, final DateTime time) async {
    await editCountdownReset(user, id, time);

    final resets = state!.sortedCopy();
    for (var i = 0; i < resets.length; i++) {
      final r = resets[i];
      if (r.id == id) resets[i] = CountdownReset(id: r.id, resetTime: time, resumeTime: r.resumeTime);
    }

    emit(CountdownTimer(
      resumed: state?.resumed,
      paused: state?.paused,
      resets: [...resets],
    ));
  }

  Future<void> editResume(final User user, final int id, final DateTime time) async {
    await editCountdownResume(user, id, time);

    final resets = state!.sortedCopy();
    for (var i = 0; i < resets.length; i++) {
      final r = resets[i];
      if (r.id == id) resets[i] = CountdownReset(id: r.id, resetTime: r.resetTime, resumeTime: time);
    }

    emit(CountdownTimer(
      resumed: state?.resumed,
      paused: state?.paused,
      resets: [...resets],
    ));
  }

  void overwrite(
    final List<CountdownReset> input,
  ) {
    final resets = [...input];
    resets.sort((final a, final b) => a.compareTo(b));

    emit(CountdownTimer(
      paused: resets.lastOrNull?.resetTime ?? DateTime.now(),
      resumed: resets.lastOrNull?.resumeTime,
      resets: [...resets],
    ));
  }
}

Future<void> startNotifications(final AppLocalizations al) async {
  await unscheduleNotification(121);
  await unscheduleNotification(122);

  await scheduleNotification(101, const Duration(hours: 1), al.notificationsTimerEvent, al.notificationsPass_1);
  await scheduleNotification(102, const Duration(hours: 2), al.notificationsTimerEvent, al.notificationsPass_2);
  await scheduleNotification(103, const Duration(hours: 24), al.notificationsTimerEvent, al.notificationsPass_24);
  await scheduleNotification(104, const Duration(hours: 48), al.notificationsTimerEvent, al.notificationsPass_48);
  await scheduleNotification(105, const Duration(hours: 72), al.notificationsTimerEvent, al.notificationsPass_72);
  await scheduleNotification(106, const Duration(hours: 96), al.notificationsTimerEvent, al.notificationsPass_96);
  await scheduleNotification(107, const Duration(hours: 168), al.notificationsTimerEvent, al.notificationsPass_168);
}

Future<void> stopNotifications(final AppLocalizations al) async {
  await scheduleNotification(121, const Duration(hours: 1), al.notificationsTimerEvent, al.notificationsHourPassReset);
  await scheduleNotification(122, const Duration(hours: 24), al.notificationsTimerEvent, al.notificationsDayPassReset);

  for (var i = 100; i < 110; i++) {
    await unscheduleNotification(i);
  }
}
