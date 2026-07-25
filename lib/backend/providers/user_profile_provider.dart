import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(() {
      return UserProfileNotifier();
    });

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  FutureOr<UserProfile?> build() async {
    // Listen to auth state changes to reload profile when user logs in/out
    // In Riverpod, listening to streams inside build should ideally use ref.watch or listen.
    // We can just listen to the stream manually.
    final sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        fetchProfile();
      } else {
        state = const AsyncData(null);
      }
    });

    ref.onDispose(() {
      sub.cancel();
    });

    return _fetch();
  }

  Future<UserProfile?> _fetch() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        final newProfile = {
          'id': user.id,
          'email': user.email ?? '',
          'full_name': user.userMetadata?['full_name'] ?? 'New User',
        };

        await Supabase.instance.client.from('profiles').insert(newProfile);
        return UserProfile.fromJson(newProfile);
      }
      return UserProfile.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchProfile() async {
    state = const AsyncLoading();
    try {
      final profile = await _fetch();
      state = AsyncData(profile);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client
          .from('profiles')
          .update(updates)
          .eq('id', user.id);
      await fetchProfile(); // Refresh profile data
    } catch (e) {
      rethrow;
    }
  }
}
