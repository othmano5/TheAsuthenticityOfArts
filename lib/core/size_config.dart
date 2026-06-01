import 'dart:ui';
import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _textScaleFactor;
  static bool _initialized = false;

  static void init(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    if (mq == null) {
      _ensureInitialized();
      return;
    }

    _mediaQueryData = mq;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _textScaleFactor = _mediaQueryData.textScaler.scale(1);
    _initialized = true;
  }

  static void _ensureInitialized() {
    if (_initialized) return;
    final view = PlatformDispatcher.instance.views.first;
    final physicalSize = view.physicalSize;
    final dpr = view.devicePixelRatio == 0 ? 1.0 : view.devicePixelRatio;
    screenWidth = physicalSize.width / dpr;
    screenHeight = physicalSize.height / dpr;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _textScaleFactor = 1.0;
    _initialized = true;
  }

  static double w(double percent) {
    _ensureInitialized();
    return blockSizeHorizontal * percent;
  }

  static double h(double percent) {
    _ensureInitialized();
    return blockSizeVertical * percent;
  }

  static bool get isMobile {
    _ensureInitialized();
    return screenWidth < 600;
  }

  static bool get isTablet {
    _ensureInitialized();
    return screenWidth >= 600 && screenWidth < 1024;
  }

  static bool get isDesktop {
    _ensureInitialized();
    return screenWidth >= 1024;
  }

  static double adaptive({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    _ensureInitialized();
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  static double sp(double size) {
    _ensureInitialized();
    final scaled = size * _textScaleFactor;
    final min = size * 0.85;
    final max = size * 1.2;
    if (scaled < min) return min;
    if (scaled > max) return max;
    return scaled;
  }
}
