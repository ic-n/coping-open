import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/storage/trigger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaticRecords {
  StaticRecords({
    required this.goals,
    required this.triggers,
  });

  List<Goal> goals;
  List<Trigger> triggers;
  bool get isEmpty => goals.isEmpty && triggers.isEmpty;

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

class StaticCubit extends Cubit<StaticRecords?> {
  StaticCubit() : super(null);

  void overwrite(final StaticRecords s) {
    emit(s);
  }
}
