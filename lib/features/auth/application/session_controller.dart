import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import 'session_state.dart';

final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(
      SessionController.new,
    );

class SessionController extends Notifier<SessionState> {
  static const _isLoggedInKey = 'is_logged_in';
  static const _roleKey = 'user_role';
  static const _tokenKey = 'api_token';

  @override
  SessionState build() {
    final preferences = ref.read(sharedPreferencesProvider);

    return SessionState(
      isAuthenticated: preferences.getBool(_isLoggedInKey) ?? false,
      role: AppUserRole.fromStorage(preferences.getString(_roleKey)),
      token: preferences.getString(_tokenKey),
    );
  }

  Future<void> signIn({
    required AppUserRole role,
    String? token,
  }) async {
    state = state.copyWith(
      isAuthenticated: true,
      role: role,
      token: token ?? 'demo-token-${role.storageValue}',
    );

    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setBool(_isLoggedInKey, true);
    await preferences.setString(_roleKey, role.storageValue);
    await preferences.setString(_tokenKey, state.token ?? '');
  }

  Future<void> signOut() async {
    state = state.copyWith(
      isAuthenticated: false,
      role: AppUserRole.guest,
      clearToken: true,
    );

    final preferences = ref.read(sharedPreferencesProvider);
    await preferences.setBool(_isLoggedInKey, false);
    await preferences.remove(_roleKey);
    await preferences.remove(_tokenKey);
  }
}
