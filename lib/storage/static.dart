import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/tools/maybe_map.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Goal>> getStaticGoals(final User user) async {
  final data = await query('goal_templates').select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  final List<Goal> gs = [];

  for (final record in data) {
    final descriptions = maybeLocalized(record['v2_descriptions']);
    final titles = maybeLocalized(record['v2_titles']);

    final g = Goal(
      id: 'static/${record['id']}',
      titles: titles,
      iconName: record['icon_name'],
      relatedAddiction: record['related_addiction'],
      author: record['author'],
      links: maybeList(record['links']),
      descriptions: descriptions,
      rate: Duration(seconds: record['rate_seconds']),
    );

    gs.add(g);
  }

  return gs;
}

Future<List<Trigger>> getStaticTriggers(final User user) async {
  final data = await query('trigger_templates').select<PostgrestList>().eq('related_addiction', 'smoking');

  if (data.isEmpty) {
    return [];
  }

  final List<Trigger> ts = [];

  for (final record in data) {
    final labels = maybeLocalized(record['v2_labels']);

    final t = Trigger(
      id: 'static/${record['id']}',
      labels: labels,
      relatedAddiction: record['related_addiction'],
      author: record['author'],
    );

    ts.add(t);
  }

  return ts;
}

SupabaseQueryBuilder query(final String name) => Supabase.instance.client.from('static_$name');
