import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/retry.dart';

const apiBase = 'discord.com';
const apiPath = '/api/guilds/[******]/widget.json';

Future<String?> discordObtainInvite() async {
  final client = RetryClient(Client());
  Map<String, dynamic> v;
  try {
    final reply = await client.read(Uri.http(apiBase, apiPath));
    v = jsonDecode(reply);
  } finally {
    client.close();
  }

  return v['instant_invite'] as String?;
}
