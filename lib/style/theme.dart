import 'package:flutter/material.dart';

enum ThemeType { light, dark }

// LIGHT GRADIENT COLORS
const _amberYellow = Color.fromRGBO(244, 188, 159, 1);
const _deepBlue = Color.fromRGBO(49, 98, 238, 1);
const _pink = Color.fromRGBO(232, 130, 204, 1);
const _blue = Color.fromRGBO(89, 181, 243, 1);

const _purpleHaze = Color.fromRGBO(105, 49, 245, 1);
const _swampyBlack = Color.fromRGBO(32, 42, 50, 1);
const _persimmonOrange = Color.fromRGBO(233, 51, 52, 1);
const _darkAmber = Color.fromRGBO(233, 160, 75, 1);

class AppColors extends ThemeExtension<AppColors> {
  final bool isDark;
  final GradientColors gradientColors;
  final Color background;
  final Color onBackground;
  final Color container;
  final Color onContainer;
  final Color transparentContainer;

  const AppColors._({
    required this.isDark,
    required this.gradientColors,
    required this.background,
    required this.onBackground,
    required this.container,
    required this.onContainer,
    required this.transparentContainer,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          isDark: false,
          gradientColors: const GradientColors(
            upperLeft: _blue,
            upperRight: _deepBlue,
            bottomLeft: _pink,
            bottomRight: _amberYellow,
          ),
          background: Colors.white,
          onBackground: Colors.black,
          container: Colors.black,
          onContainer: Colors.white,
          transparentContainer: Colors.black.withOpacity(0.15),
        );
      case ThemeType.dark:
        return AppColors._(
          isDark: true,
          gradientColors: const GradientColors(
            upperLeft: _swampyBlack,
            upperRight: _persimmonOrange,
            bottomLeft: _purpleHaze,
            bottomRight: _darkAmber,
          ),
          background: Colors.black,
          onBackground: Colors.white,
          container: Colors.white,
          onContainer: Colors.black,
          transparentContainer: Colors.white.withOpacity(0.15),
        );
    }
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  ThemeData toThemeData() {
    final themeData = ThemeData(
      scaffoldBackgroundColor: background,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: 'Inter',
    ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
        primary: isDark ? Colors.white : Colors.black,
        secondary: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  AppColors copyWith({
    bool? isDark,
    GradientColors? gradientColors,
    Color? background,
    Color? onBackground,
    Color? container,
    Color? onContainer,
    Color? transparentContainer,
  }) {
    return AppColors._(
      isDark: isDark ?? this.isDark,
      gradientColors: gradientColors ?? this.gradientColors,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      container: container ?? this.onContainer,
      onContainer: onContainer ?? this.onContainer,
      transparentContainer: transparentContainer ?? this.transparentContainer,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      // Immediately update whether the theme is dark when the theme is changed
      // in order to immediately trigger listeners that run custom animations.
      isDark: other.isDark,
      gradientColors: gradientColors.lerpTo(other.gradientColors, t),
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      container: Color.lerp(container, other.container, t)!,
      onContainer: Color.lerp(onContainer, other.onContainer, t)!,
      transparentContainer: Color.lerp(transparentContainer, other.transparentContainer, t)!,
    );
  }
}

class GradientColors {
  final Color upperLeft;
  final Color upperRight;
  final Color bottomLeft;
  final Color bottomRight;

  const GradientColors({
    required this.upperLeft,
    required this.upperRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  GradientColors lerpTo(GradientColors other, double t) {
    return GradientColors(
      upperLeft: Color.lerp(upperLeft, other.upperLeft, t)!,
      upperRight: Color.lerp(upperRight, other.upperRight, t)!,
      bottomLeft: Color.lerp(bottomLeft, other.bottomLeft, t)!,
      bottomRight: Color.lerp(bottomRight, other.bottomRight, t)!,
    );
  }
}
