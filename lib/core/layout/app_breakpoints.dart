import 'package:flutter/widgets.dart';

class AppBreakpoints {
  static const double tablet = 720;
  static const double desktop = 1100;
  static const double wideDesktop = 1440;

  static bool isTabletWidth(double width) => width >= tablet;

  static bool isDesktopWidth(double width) => width >= desktop;

  static double horizontalPadding(double width) {
    if (width >= wideDesktop) {
      return 48;
    }

    if (width >= desktop) {
      return 36;
    }

    if (width >= tablet) {
      return 28;
    }

    return 20;
  }

  static int adaptiveColumns(double width) {
    if (width >= desktop) {
      return 3;
    }

    if (width >= tablet) {
      return 2;
    }

    return 1;
  }

  static double contentWidth(double width) {
    if (width >= wideDesktop) {
      return 1280;
    }

    if (width >= desktop) {
      return 1120;
    }

    return width;
  }
}
