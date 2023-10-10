import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TriggerLog {
  const TriggerLog({
    required this.labels,
    required this.situation,
    required this.thought,
    required this.impulse,
    required this.time,
  });

  final Map<String, String> labels;
  final String situation;
  final String thought;
  final int impulse;
  final DateTime time;
}

Future<void> logTrigger(final User user, final Trigger t, final String situation, final String thought, final int impulse) async {
  await query().insert({
    'user_id': user.id,
    'meta_id': t.id,
    'addiction_type': t.relatedAddiction,
    'label': t.labels,
    'situation': situation,
    'thought': thought,
    'impulse': impulse,
  });
}

Future<List<TriggerLog>> getTriggersLog(final User user, final String type) async {
  final data = await query().select<PostgrestList>().eq('user_id', user.id).eq('addiction_type', type);

  final List<TriggerLog> result = [];
  for (final r in data) {
    final labels = maybeLocalized(r['label']);

    result.add(TriggerLog(
      labels: labels,
      situation: r['situation'],
      thought: r['thought'],
      impulse: int.parse(r['impulse'].toString()),
      time: DateTime.parse(r['created_at']).toLocal(),
    ));
  }

  return result;
}

SupabaseQueryBuilder query() => Supabase.instance.client.from('trigger_logs');
