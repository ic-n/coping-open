import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRecord {
  ProfileRecord({
    required this.firstName,
    required this.secondName,
    required this.breathingTime,
    required this.addictionLabel,
    required this.color,
    required this.isLight,
  });

  String firstName;
  String secondName;
  double breathingTime;
  String addictionLabel; // addiction_label
  String? color;
  bool? isLight;
}

Future<ProfileRecord?> getProfile(final User user) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  if (data.isEmpty) {
    return ProfileRecord(
      firstName: '',
      secondName: '',
      breathingTime: 6,
      addictionLabel: '',
      color: null,
      isLight: null,
    );
  }

  final record = data[0];
  var breathingTime = double.parse((record['breathing_time'] ?? '6').toString());
  if (breathingTime < 3 || breathingTime > 32) breathingTime = 6;

  final Map<String, dynamic> themeData = jsonDecode(record['theme'] ?? '{}');

  return ProfileRecord(
    firstName: record['first_name'] ?? '',
    secondName: record['second_name'] ?? '',
    breathingTime: breathingTime,
    addictionLabel: record['addiction_label'] ?? '',
    color: themeData['color'],
    isLight: themeData['is_light'],
  );
}

Future<void> syncProfile(final User user, final ProfileRecord p) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  if (data.isEmpty) {
    await query().insert({
      'user_id': user.id,
      'first_name': p.firstName,
      'second_name': p.secondName,
      'addiction_label': p.addictionLabel,
    });
    return;
  }

  await query().update({
    'user_id': user.id,
    'first_name': p.firstName,
    'second_name': p.secondName,
    'addiction_label': p.addictionLabel,
  }).eq('user_id', user.id);
}

Future<void> syncProfileBreathingTime(final User user, final double breathingTime) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  if (data.isEmpty) {
    await query().insert({
      'user_id': user.id,
      'breathing_time': breathingTime,
    });
    return;
  }

  await query().update({
    'user_id': user.id,
    'breathing_time': breathingTime,
  }).eq('user_id', user.id);
}

Future<void> syncProfileTheme(final User user, final String color, {final bool isLight = false}) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  final String theme = jsonEncode({
    'color': color,
    'is_light': isLight,
  });

  if (data.isEmpty) {
    await query().insert({
      'user_id': user.id,
      'theme': theme,
    });
    return;
  }

  await query().update({
    'user_id': user.id,
    'theme': theme,
  }).eq('user_id', user.id);
}

SupabaseQueryBuilder query() => Supabase.instance.client.from('profiles');
