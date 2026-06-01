import 'package:flutter/material.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 64,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
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
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: scheme.onPrimary,
            size: size * 0.34,
          ),
          SizedBox(height: size * 0.05),
          Text(
            'AF',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: scheme.onPrimary,
              fontFamily: 'Sora',
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
