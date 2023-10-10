import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Triggers {
  Triggers(this.templates, this.triggerLog);

  List<Trigger> templates;
  List<TriggerLog> triggerLog;

  List<TriggerLog> get log => triggerLog.toList()..sort((final a, final b) => b.time.compareTo(a.time));

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

class TriggersCubit extends Cubit<Triggers?> {
  TriggersCubit() : super(null);

  Future<void> toggle(final User user, final Trigger trigger) async {
    if (state != null) {
      final List<Trigger> d = [];
      final Set<String> seen = {};

      for (final t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      if (d.where((final element) => trigger.id == element.id).isEmpty) {
        d.add(trigger);
      } else {
        d.removeWhere((final element) => trigger.id == element.id);
      }

      final log = state!.triggerLog;

      emit(Triggers(d, log));
      await syncTriggers(user, [...d]);
    }
  }

  Future<void> addPersonal(final User user, final String label) async {
    if (state != null) {
      final List<Trigger> d = [];
      final Set<String> seen = {};

      for (final t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      d.add(Trigger(id: 'personal/$label', labels: {'en': label}, relatedAddiction: 'smoking'));

      final log = state!.triggerLog;

      emit(Triggers(d, log));
      await syncTriggers(user, [...d]);
    }
  }

  Future<void> removePersonal(final User user, final String id) async {
    if (state != null) {
      final List<Trigger> d = [];
      final Set<String> seen = {};

      for (final t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      d.removeWhere((final element) => id == element.id);

      final log = state!.triggerLog;

      emit(Triggers(d, log));
      await syncTriggers(user, [...d]);
    }
  }

  Future<void> send(final User user, final Trigger trigger, final String situation, final String thought, final int impulse) async {
    if (state != null) {
      final List<Trigger> d = [];
      final Set<String> seen = {};

      for (final t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      await logTrigger(user, trigger, situation, thought, impulse);

      final log = state!.triggerLog;
      log.add(TriggerLog(
        labels: trigger.labels,
        situation: situation,
        thought: thought,
        impulse: impulse,
        time: DateTime.now(),
      ));

      emit(Triggers(d, log));
      await syncTriggers(user, [...d]);
    }
  }

  void overwrite(final Triggers triggers) {
    final List<Trigger> d = [];
    final Set<String> seen = {};

    for (final t in triggers.templates) {
      if (seen.contains(t.id)) continue;
      seen.add(t.id);

      d.add(t);
    }

    emit(Triggers(d, triggers.triggerLog));
  }
}
