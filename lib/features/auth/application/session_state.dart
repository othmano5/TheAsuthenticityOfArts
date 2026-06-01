enum AppUserRole {
  guest,
  user,
  admin;

  String get storageValue => switch (this) {
    AppUserRole.guest => 'guest',
    AppUserRole.user => 'user',
    AppUserRole.admin => 'admin',
  };

  String get label => switch (this) {
    AppUserRole.guest => 'زائر',
    AppUserRole.user => 'مستخدم',
    AppUserRole.admin => 'مسؤول',
  };

  String get homePath => switch (this) {
    AppUserRole.guest => '/',
    AppUserRole.user => '/users',
    AppUserRole.admin => '/admin',
  };

  static AppUserRole fromStorage(String? value) {
    return AppUserRole.values.firstWhere(
      (role) => role.storageValue == value,
      orElse: () => AppUserRole.guest,
    );
  }
}

class SessionState {
  const SessionState({
    required this.isAuthenticated,
    required this.role,
    this.token,
  });

  final bool isAuthenticated;
  final AppUserRole role;
  final String? token;

  SessionState copyWith({
    bool? isAuthenticated,
    AppUserRole? role,
    String? token,
    bool clearToken = false,
  }) {
    return SessionState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      role: role ?? this.role,
      token: clearToken ? null : token ?? this.token,
    );
  }
}
