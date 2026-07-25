import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_profile.dart';

abstract class AuthRepository {
  Stream<supabase.AuthState> get authStateChanges;

  supabase.User? get currentUser;

  Future<UserProfile?> getCurrentUserProfile();

  Future<void> signInWithEmail(String email, String password);

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? gender,
  });

  Future<void> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> updateProfile(Map<String, dynamic> updates);

  Future<String> uploadProfilePhoto(String fileName, Uint8List fileBytes);
}
