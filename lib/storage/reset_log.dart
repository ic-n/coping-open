import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownReset {
  const CountdownReset({
    required this.id,
    required this.resetTime,
    required this.resumeTime,
  });

  final int id; // id
  final DateTime resetTime; // reset_time
  final DateTime? resumeTime; // resume_time

  int compareTo(final CountdownReset other) {
    final art = resumeTime;
    final brt = other.resumeTime;

    if (art == null && brt == null) {
      return resetTime.compareTo(other.resetTime);
    }

    if (art == null) {
      return 1;
    }
    if (brt == null) {
      return -1;
    }

    return art.compareTo(brt);
  }
}

Future<List<CountdownReset>> getCountdownResets(final User user, final String type) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type);

  if (data.isEmpty) {
    return [];
  }

  final List<CountdownReset> crs = [];

  for (final record in data) {
    var resume = DateTime.tryParse(record['resume_time'] ?? '');
    if (resume != null) resume = resume.toLocal();

    final cr = CountdownReset(
      id: record['id'],
      resetTime: DateTime.parse(record['reset_time']).toLocal(),
      resumeTime: resume,
    );

    crs.add(cr);
  }

  return crs;
}

Future<int> logCountdownResume(final User user, final String type, final DateTime time) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type).is_('resume_time', null);

  if (data.isEmpty) {
    final List<dynamic> d = await query().insert({
      'user_id': user.id,
      'reset_time': time.toUtc().toIso8601String(),
      'resume_time': time.toUtc().toIso8601String(),
      'addiction_type': type,
    }).select('id');

    final Map<String, dynamic> v = d[0];

    return int.parse(v['id'].toString());
  }

  await query()
      .update({
        'id': data[0]['id'],
        'user_id': user.id,
        'resume_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', data[0]['id']);

  return int.parse(data[0]['id'].toString());
}

Future<int> logCountdownReset(final User user, final String type, final DateTime time) async {
  final List<dynamic> d = await query().insert({
    'user_id': user.id,
    'reset_time': time.toUtc().toIso8601String(),
    'addiction_type': type,
  }).select('id');

  final Map<String, dynamic> v = d[0];

  return int.parse(v['id'].toString());
}

Future<void> editCountdownReset(final User user, final int id, final DateTime time) async {
  await query()
      .update({
        'id': id,
        'user_id': user.id,
        'reset_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', id);

  return;
}

Future<void> editCountdownResume(final User user, final int id, final DateTime time) async {
  await query()
      .update({
        'id': id,
        'user_id': user.id,
        'resume_time': time.toUtc().toIso8601String(),
      })
      .eq('user_id', user.id)
      .eq('id', id);

  return;
}

SupabaseQueryBuilder query() => Supabase.instance.client.from('addiction_reset_log');
