import 'package:supabase_flutter/supabase_flutter.dart';

Future<User?> supalogin(final String email, final String password) async {
  final db = Supabase.instance.client;

  final AuthResponse res = await db.auth.signInWithPassword(
    email: email,
    password: password,
  );

  return res.user;
}

Future<User?> suparegister(final String email, final String password) async {
  final db = Supabase.instance.client;

  final AuthResponse res = await db.auth.signUp(
    email: email,
    password: password,
  );

  return res.user;
}
