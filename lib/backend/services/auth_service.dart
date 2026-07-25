import '../repositories/auth_repository.dart';
import '../models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthService {
  final AuthRepository _repository;

  AuthService(this._repository);

  Stream<supabase.AuthState> get authStateChanges =>
      _repository.authStateChanges;

  supabase.User? get currentUser => _repository.currentUser;

  Future<UserProfile?> getCurrentUserProfile() {
    return _repository.getCurrentUserProfile();
  }

  Future<void> login(String email, String password) {
    return _repository.signInWithEmail(email, password);
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? gender,
  }) {
    return _repository.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
      gender: gender,
    );
  }

  Future<void> loginWithGoogle() {
    return _repository.signInWithGoogle();
  }

  Future<void> logout() {
    return _repository.signOut();
  }

  Future<void> forgotPassword(String email) {
    return _repository.sendPasswordResetEmail(email);
  }

  Future<void> resetPassword(String newPassword) {
    return _repository.updatePassword(newPassword);
  }
}
