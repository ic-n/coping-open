import 'package:dependencecoping/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Trigger {
  Trigger({
    required this.id,
    required this.labels,
    required this.relatedAddiction,
    this.author,
  });

  String id;
  Map<String, String> labels; // label
  String relatedAddiction; // related_addiction
  String? author; // author
}

Future<void> syncTriggers(final User user, final List<Trigger> triggers) async {
  final data = await query().select<PostgrestList>().eq(
        'user_id',
        user.id,
      );

  for (final t in triggers) {
    final rec = {
      'label': t.labels,
      'related_addiction': t.relatedAddiction,
    };

    final existant = data.where((final element) => element['meta_id'] == t.id).firstOrNull;

    if (existant != null) {
      await query().update(rec).eq('user_id', user.id).eq('meta_id', t.id);
      continue;
    }

    rec['user_id'] = user.id;
    rec['meta_id'] = t.id;

    await query().insert(rec);
  }

  final nonExistant = data.where((final src) => triggers.where((final t) => src['meta_id'] == t.id).firstOrNull == null);
  for (final element in nonExistant) {
    await query().delete().eq('user_id', user.id).eq('meta_id', element['meta_id']);
  }
}

Future<List<Trigger>> getTriggers(final User user) async {
  final data = await query().select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  final List<Trigger> ts = [];

  for (final record in data) {
    final labels = maybeLocalized(record['label']);

    final t = Trigger(
      id: record['meta_id'],
      labels: labels,
      relatedAddiction: record['related_addiction'],
    );

    ts.add(t);
  }

  return ts;
}

SupabaseQueryBuilder query() => Supabase.instance.client.from('triggers');
