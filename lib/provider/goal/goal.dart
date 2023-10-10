import 'package:dependencecoping/storage/goal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Goals {
  Goals(this.data);

  List<Goal> data;

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

class GoalsCubit extends Cubit<Goals?> {
  GoalsCubit() : super(null);

  Future<void> set(final User user, final Goals goals) async {
    emit(goals);
    await syncGoals(user, [...goals.data]);
  }

  void overwrite(final Goals goals) {
    emit(goals);
  }
}
