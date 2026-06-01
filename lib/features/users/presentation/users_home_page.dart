import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/app_breakpoints.dart';
import '../../../shared/widgets/app_logo_mark.dart';
import '../../auth/application/session_controller.dart';
import 'pages/users_categories_page.dart';
import 'pages/users_main_page.dart';
import 'pages/users_profile_page.dart';
import 'users_navigation.dart';

class UsersHomePage extends ConsumerWidget {
  const UsersHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = AppBreakpoints.horizontalPadding(width);
    final contentWidth = AppBreakpoints.contentWidth(width);
    final selectedIndex = ref.watch(userBottomNavProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 112,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              10,
              horizontalPadding,
              0,
            ),
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  const AppLogoMark(size: 42),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _titleForTab(selectedIndex),
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const _LogoutAction(size: 42),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.74),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -30,
              child: _GlowBubble(
                size: 180,
                color: scheme.secondary.withValues(alpha: 0.14),
              ),
            ),
            Positioned(
              left: -60,
              top: 180,
              child: _GlowBubble(
                size: 140,
                color: scheme.tertiary.withValues(alpha: 0.12),
              ),
            ),
            IndexedStack(
              index: selectedIndex,
              children: const [
                UsersMainPage(),
                UsersCategoriesPage(),
                UsersProfilePage(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: scheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 76,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                ref.read(userBottomNavProvider.notifier).setIndex(index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'الرئيسية',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'الأقسام',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'المعلومات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _titleForTab(int index) {
  switch (index) {
    case 1:
      return 'الأقسام';
    case 2:
      return 'المعلومات الشخصية';
    default:
      return 'الرئيسية';
  }
}

class _LogoutAction extends ConsumerWidget {
  const _LogoutAction({this.size = 56});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.34),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.secondary, scheme.primary],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.16),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: IconButton(
        tooltip: 'تسجيل الخروج',
        onPressed: () => _confirmSignOut(context, ref),
        icon: Icon(
          Icons.logout_rounded,
          color: scheme.onPrimary,
          size: size * 0.42,
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actionsOverflowButtonSpacing: 10,
          title: const Text('تأكيد تسجيل الخروج'),
          content: const Text(
            'هل أنت متأكد من تسجيل الخروج والعودة إلى صفحة الدخول؟',
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        side: BorderSide(color: scheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('تسجيل الخروج'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true) {
      return;
    }

    await ref.read(sessionControllerProvider.notifier).signOut();
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
