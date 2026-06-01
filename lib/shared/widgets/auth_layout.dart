import 'package:flutter/material.dart';

import '../../core/layout/app_breakpoints.dart';
import 'app_logo_mark.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.highlights = const [],
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.72),
              Theme.of(context).scaffoldBackgroundColor,
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final isDesktop = AppBreakpoints.isDesktopWidth(width);
                    final horizontalPadding =
                        AppBreakpoints.horizontalPadding(width);

                    return Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: AppBreakpoints.contentWidth(width),
                          ),
                          child: isDesktop
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: _ShowcasePanel(
                                        eyebrow: eyebrow,
                                        title: title,
                                        subtitle: subtitle,
                                        highlights: highlights,
                                      ),
                                    ),
                                    const SizedBox(width: 28),
                                    Expanded(
                                      flex: 4,
                                      child: _FormCard(child: child),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    _ShowcasePanel(
                                      eyebrow: eyebrow,
                                      title: title,
                                      subtitle: subtitle,
                                      highlights: highlights,
                                      compact: true,
                                    ),
                                    const SizedBox(height: 20),
                                    _FormCard(child: child),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Center(child: footer!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowcasePanel extends StatelessWidget {
  const _ShowcasePanel({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.highlights,
    this.compact = false,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<String> highlights;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(compact ? 22 : 32),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLogoMark(size: 70),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(eyebrow, style: textTheme.labelLarge),
          ),
          const SizedBox(height: 18),
          Text(title, style: textTheme.displayMedium),
          const SizedBox(height: 12),
          Text(subtitle, style: textTheme.bodyLarge),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: highlights
                .map(
                  (item) => Chip(
                    avatar: Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: scheme.primary,
                    ),
                    label: Text(item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 32,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}
