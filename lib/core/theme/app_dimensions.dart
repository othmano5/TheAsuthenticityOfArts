import '../size_config.dart';

class AppDimensions {
  // Spacing
  static double get xSmall => SizeConfig.adaptive(mobile: SizeConfig.w(2));
  static double get small => SizeConfig.adaptive(mobile: SizeConfig.w(3));
  static double get medium =>
      SizeConfig.adaptive(mobile: SizeConfig.w(4), tablet: SizeConfig.w(3));
  static double get large =>
      SizeConfig.adaptive(mobile: SizeConfig.w(6), tablet: SizeConfig.w(4));
  static double get xLarge =>
      SizeConfig.adaptive(mobile: SizeConfig.w(8), tablet: SizeConfig.w(5));

  // Radius
  static double get radiusSmall => SizeConfig.adaptive(mobile: SizeConfig.w(2));
  static double get radiusMedium =>
      SizeConfig.adaptive(mobile: SizeConfig.w(3), tablet: SizeConfig.w(2));
  static double get radiusLarge =>
      SizeConfig.adaptive(mobile: SizeConfig.w(4), tablet: SizeConfig.w(2.8));

  // Components
  static double get buttonHeight =>
      SizeConfig.adaptive(mobile: SizeConfig.h(6), tablet: SizeConfig.h(5));
  static double get inputHeight =>
      SizeConfig.adaptive(mobile: SizeConfig.h(6.2), tablet: SizeConfig.h(5.2));
  static double get iconSmall => SizeConfig.adaptive(mobile: SizeConfig.w(4));
  static double get iconMedium =>
      SizeConfig.adaptive(mobile: SizeConfig.w(6), tablet: SizeConfig.w(4));
  static double get iconLarge =>
      SizeConfig.adaptive(mobile: SizeConfig.w(8), tablet: SizeConfig.w(5));
}
