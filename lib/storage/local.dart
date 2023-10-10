import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> restoreAuthInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? stored = prefs.getString('v2/auth');
  if (stored == null) {
    return null;
  }

  final auth = User.fromJson(jsonDecode(stored));

  return auth;
}

Future<void> storeAuthInfo(final User auth) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('v2/auth', jsonEncode(auth.toJson()));
}

class Credentials {
  String? email;
  String? password;

  bool isNotNull() => email != null && password != null;
}

Future<Credentials> restoreCredentials() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final c = Credentials();
  c.email = prefs.getString('v2/auth/email');
  c.password = prefs.getString('v2/auth/password');

  return c;
}

Future<void> storeCredentials(final String email, final String password) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('v2/auth/email', email);
  await prefs.setString('v2/auth/password', password);
}

Future<void> clearCredentials() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('v2/auth/email');
  await prefs.remove('v2/auth/password');
}

Future<void> clearLocalStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
