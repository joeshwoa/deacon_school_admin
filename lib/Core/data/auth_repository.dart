import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

class AuthRepository {
  SupabaseClient get _db => SupabaseService.client;

  bool get isLoggedIn => SupabaseService.isReady && _db.auth.currentUser != null;

  String? get currentEmail => _db.auth.currentUser?.email;

  Stream<AuthState>? get authChanges =>
      SupabaseService.isReady ? _db.auth.onAuthStateChange : null;

  Future<void> signIn({required String email, required String password}) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    if (!SupabaseService.isReady) return;
    await _db.auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    if (!SupabaseService.isReady) throw const BackendNotConnected();
    await _db.auth.resetPasswordForEmail(email);
  }
}
