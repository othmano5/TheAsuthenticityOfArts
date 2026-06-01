import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route/router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.travel_explore_rounded,
                        size: 72,
                        color: scheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text('الصفحة غير موجودة', style: textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      Text(
                        'الرابط الذي طلبته غير متاح حالياً. يمكنك العودة للواجهة الرئيسية ومتابعة العمل.',
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => context.go(AppRoute.login.path),
                        child: const Text('العودة إلى البداية'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
