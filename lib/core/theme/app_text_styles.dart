import 'package:flutter/material.dart';

class AppTextStyles {
  static const List<String> _fallbackFonts = ['Sora'];

  static const TextStyle _displayBase = TextStyle(
    fontFamily: 'Sora',
    fontFamilyFallback: _fallbackFonts,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: -0.7,
  );

  static const TextStyle _headlineBase = TextStyle(
    fontFamily: 'Almarai',
    fontFamilyFallback: _fallbackFonts,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle _titleBase = TextStyle(
    fontFamily: 'Almarai',
    fontFamilyFallback: _fallbackFonts,
    fontWeight: FontWeight.w700,
    height: 1.28,
  );

  static const TextStyle _bodyBase = TextStyle(
    fontFamily: 'Almarai',
    fontFamilyFallback: _fallbackFonts,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static const TextStyle _labelBase = TextStyle(
    fontFamily: 'Almarai',
    fontFamilyFallback: _fallbackFonts,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextTheme textTheme(ColorScheme scheme) {
    return TextTheme(
      displayLarge: _displayBase.copyWith(
        fontSize: 44,
        color: scheme.onSurface,
      ),
      displayMedium: _displayBase.copyWith(
        fontSize: 34,
        color: scheme.onSurface,
      ),
      headlineLarge: _headlineBase.copyWith(
        fontSize: 28,
        color: scheme.onSurface,
      ),
      headlineMedium: _headlineBase.copyWith(
        fontSize: 24,
        color: scheme.onSurface,
      ),
      titleLarge: _titleBase.copyWith(
        fontSize: 20,
        color: scheme.onSurface,
      ),
      titleMedium: _titleBase.copyWith(
        fontSize: 17,
        color: scheme.onSurface,
      ),
      bodyLarge: _bodyBase.copyWith(
        fontSize: 16,
        color: scheme.onSurface,
      ),
      bodyMedium: _bodyBase.copyWith(
        fontSize: 14,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: _labelBase.copyWith(
        fontSize: 15,
        color: scheme.onSurface,
      ),
      labelMedium: _labelBase.copyWith(
        fontSize: 13,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
