import 'package:flutter/material.dart';

import 'app_logo_mark.dart';

class AuthPageFrame extends StatelessWidget {
  const AuthPageFrame({
    super.key,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.maxWidth = 520,
  });

  final String badge;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final onBrandColor = scheme.onPrimary;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.primaryContainer.withValues(alpha: 0.84),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -90,
            left: -40,
            child: _GlowBubble(
              size: 220,
              color: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            top: 120,
            right: -50,
            child: _GlowBubble(
              size: 180,
              color: scheme.tertiary.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            bottom: -80,
            left: 30,
            child: _GlowBubble(
              size: 200,
              color: scheme.primary.withValues(alpha: 0.10),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surface.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(color: scheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.shadow.withValues(alpha: 0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 24),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(34),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    scheme.primary,
                                    scheme.secondary,
                                  ],
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppLogoMark(size: 72),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: onBrandColor.withValues(
                                              alpha: 0.18,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                          child: Text(
                                            badge,
                                            style: textTheme.labelLarge
                                                ?.copyWith(
                                                  color: onBrandColor,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          title,
                                          style: textTheme.headlineMedium
                                              ?.copyWith(
                                                color: onBrandColor,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          subtitle,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: onBrandColor.withValues(
                                              alpha: 0.86,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: child,
                            ),
                          ],
                        ),
                      ),
                      if (footer != null) ...[
                        const SizedBox(height: 14),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 90,
              spreadRadius: 18,
            ),
          ],
        ),
      ),
    );
  }
}
