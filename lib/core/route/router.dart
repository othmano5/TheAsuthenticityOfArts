import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_home_page.dart';
import '../../features/auth/application/session_controller.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/users/presentation/users_home_page.dart';
import '../not_found_page.dart';

enum AppRoute {
  login('/'),
  register('/register'),
  admin('/admin'),
  users('/users');

  const AppRoute(this.path);

  final String path;
}

final routerProvider = Provider<GoRouter>((ref) {
  final session = ref.watch(sessionControllerProvider);

  return GoRouter(
    initialLocation: AppRoute.login.path,
    errorBuilder: (context, state) => const NotFoundPage(),
    redirect: (context, state) {
      final location = state.uri.path;
      final isLogin = location == AppRoute.login.path;
      final isRegister = location == AppRoute.register.path;

      if (!session.isAuthenticated) {
        return isLogin || isRegister ? null : AppRoute.login.path;
      }

      if (isLogin || isRegister) {
        return session.role.homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.login.path,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoute.admin.path,
        builder: (context, state) => const AdminHomePage(),
      ),
      GoRoute(
        path: AppRoute.users.path,
        builder: (context, state) => const UsersHomePage(),
      ),
    ],
  );
});
