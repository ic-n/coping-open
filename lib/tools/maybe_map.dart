import 'dart:convert';

Map<String, String> maybeLocalized(final dynamic d) {
  if (d.runtimeType == String) {
    if (d.toString().startsWith('{')) return Map<String, String>.from(jsonDecode(d));
    return {'en': d.toString()};
  }

  return Map<String, String>.from(d);
}

List<String> maybeList(final dynamic d) {
  if (d == null) return [];

  if (d.runtimeType == String) {
    return jsonDecode(d);
  }

  if (d.runtimeType == List<dynamic>) {
    final List<dynamic> l = d;
    return l.map((final e) => e.toString()).toList();
  }

  return d;
}
