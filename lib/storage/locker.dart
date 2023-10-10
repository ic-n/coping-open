import 'package:supabase_flutter/supabase_flutter.dart';

class LockerSet {
  const LockerSet({
    required this.id,
    required this.start,
    required this.end,
  });

  final int id;
  final DateTime start;
  final DateTime end;

  int compareTo(final LockerSet other) => start.compareTo(other.start);

  @override
  String toString() => 'LockerSet($id, $start -> $end)';
}

Future<List<LockerSet>> getLockerSets(final User user) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).order('start_at');

  if (data.isEmpty) {
    return [];
  }

  final List<LockerSet> lss = [];

  for (final record in data) {
    final ls = LockerSet(
      id: record['id'],
      start: DateTime.parse(record['start_at']).toLocal(),
      end: DateTime.parse(record['end_at']).toLocal(),
    );

    lss.add(ls);
  }

  return lss;
}

Future<int> createLocker(
  final User user,
  final DateTime start,
  final DateTime end,
) async {
  final List<dynamic> d = await query().insert({
    'user_id': user.id,
    'start_at': start.toUtc().toIso8601String(),
    'end_at': end.toUtc().toIso8601String(),
  }).select('id');

  final Map<String, dynamic> v = d[0];

  return int.parse(v['id'].toString());
}

SupabaseQueryBuilder query() => Supabase.instance.client.from('locker_sets');
