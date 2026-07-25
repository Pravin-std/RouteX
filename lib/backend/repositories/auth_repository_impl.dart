import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'auth_repository.dart';
import '../models/user_profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient _supabaseClient;

  AuthRepositoryImpl({
    required supabase.SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  @override
  Stream<supabase.AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  @override
  supabase.User? get currentUser => _supabaseClient.auth.currentUser;

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) return null;
      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      debugPrint('[AuthRepository] Attempting signInWithEmail for: $email');
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint(
        '[AuthRepository] signInWithEmail successful. User ID: ${response.user?.id}, Session: ${response.session != null}',
      );
    } on supabase.AuthException catch (authError) {
      debugPrint(
        '[AuthRepository] AuthException during signInWithEmail: ${authError.message}',
      );
      debugPrint(
        '[AuthRepository] AuthException status code: ${authError.statusCode}',
      );
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Unknown error during signInWithEmail: $e');
      rethrow;
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? gender,
  }) async {
    try {
      debugPrint('[AuthRepository] Starting signUpWithEmail for: $email');
      // 1. Sign up the user
      final authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone_number': phoneNumber,
          'gender': gender,
        },
      );

      final user = authResponse.user;
      debugPrint(
        '[AuthRepository] Auth signUp successful. User ID: ${user?.id}, Session: ${authResponse.session != null}',
      );

      if (user == null) {
        debugPrint('[AuthRepository] User is null after signUp');
      }
    } on supabase.AuthException catch (authError) {
      debugPrint(
        '[AuthRepository] AuthException during signUp: ${authError.message}',
      );
      rethrow;
    } catch (e) {
      debugPrint('[AuthRepository] Unknown error during signUp: $e');
      rethrow;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _supabaseClient.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabaseClient.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final user = currentUser;
    if (user == null) throw Exception('No user logged in');
    try {
      await _supabaseClient.from('profiles').update(updates).eq('id', user.id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> uploadProfilePhoto(
    String fileName,
    Uint8List fileBytes,
  ) async {
    final user = currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      final storagePath = '${user.id}/$fileName';

      await _supabaseClient.storage
          .from('avatars')
          .uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: const supabase.FileOptions(upsert: true),
          );

      return _supabaseClient.storage.from('avatars').getPublicUrl(storagePath);
    } catch (e) {
      rethrow;
    }
  }
}
