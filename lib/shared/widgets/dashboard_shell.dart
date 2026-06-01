import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layout/app_breakpoints.dart';
import '../../features/auth/application/session_controller.dart';
import 'app_logo_mark.dart';

class DashboardFeature {
  const DashboardFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class DashboardShell extends ConsumerWidget {
  const DashboardShell({
    super.key,
    required this.roleLabel,
    required this.title,
    required this.subtitle,
    required this.features,
  });

  final String roleLabel;
  final String title;
  final String subtitle;
  final List<DashboardFeature> features;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.68),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = AppBreakpoints.horizontalPadding(width);
              final contentWidth = math.min(
                width,
                AppBreakpoints.contentWidth(width),
              );
              final isDesktop = AppBreakpoints.isDesktopWidth(width);
              final columns = AppBreakpoints.adaptiveColumns(contentWidth);
              final availableWidth = contentWidth - (horizontalPadding * 2);
              final cardWidth = columns == 1
                  ? double.infinity
                  : (availableWidth - (20 * (columns - 1))) / columns;

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const AppLogoMark(),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'أصالة الفنون',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    Text(
                                      roleLabel,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                ref
                                    .read(sessionControllerProvider.notifier)
                                    .signOut();
                              },
                              icon: const Icon(Icons.logout_rounded),
                              label: const Text('خروج'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isDesktop ? 32 : 24),
                          decoration: BoxDecoration(
                            color: scheme.surface.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: scheme.outlineVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: scheme.secondary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  roleLabel,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                title,
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: features
                              .map(
                                (feature) => SizedBox(
                                  width: cardWidth,
                                  child: _FeatureCard(feature: feature),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final DashboardFeature feature;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(feature.icon, color: scheme.primary),
          const SizedBox(height: 16),
          Text(feature.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
