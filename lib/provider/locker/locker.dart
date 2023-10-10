import 'package:dependencecoping/storage/locker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Locker {
  const Locker({
    this.start,
    this.duration = Duration.zero,
    this.positive = false,
  });

  final DateTime? start;
  final Duration duration;
  final bool positive;

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

class LockerCubit extends Cubit<Locker> {
  LockerCubit() : super(const Locker());

  Future<void> start(final User user, final DateTime start, final Duration duration) async {
    emit(Locker(
      start: start,
      duration: duration,
    ));
    await createLocker(user, start, start.add(duration));
  }

  Future<void> stop(final User user) async {
    final start = DateTime.now();
    emit(const Locker());
    await createLocker(user, start, start);
  }

  Future<void> notifyDone(final User user) async {
    final start = DateTime.now();
    emit(const Locker(positive: true));
    await createLocker(user, start, start);
  }

  void overwrite(final DateTime start, final Duration duration) {
    emit(Locker(
      start: start,
      duration: duration,
    ));
  }
}
