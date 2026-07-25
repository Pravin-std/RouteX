import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/services/auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final repository = AuthRepositoryImpl(
    supabaseClient: supabase.Supabase.instance.client,
  );
  return AuthService(repository);
});

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {


  AuthService get _authService => ref.read(authServiceProvider);

  @override
  AuthState build() {
    _init();
    return const AuthState();
  }

  void _init() {
    // We defer listening to avoid modifying state during build if it fires synchronously
    Future.microtask(() {
      _authService.authStateChanges.listen((data) {
        final session = data.session;
        if (session != null) {
          state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null);
        }
      });
    });
  }

  // Notifier doesn't have a direct dispose, but we can use ref.onDispose
  // Wait, in build we can do ref.onDispose
  // Let's move it there:

  /*
  @override
  AuthState build() {
    ref.onDispose(() {
      _authStateSubscription?.cancel();
    });
    _init();
    return const AuthState();
  }
  */

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.login(email, password);
      // State updated via listener
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    String? gender,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        gender: gender,
      );
      // State updated via listener
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.loginWithGoogle();
      // State updated via listener
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.logout();
      // State updated via listener
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authService.forgotPassword(email);
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}
