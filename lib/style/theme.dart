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
  final Color headerColor;
  final Color transparentContainer;

  const AppColors._({
    required this.isDark,
    required this.gradientColors,
    required this.headerColor,
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
          headerColor: Colors.black,
          transparentContainer: Colors.black.withOpacity(0.25),
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
          headerColor: Colors.white,
          transparentContainer: Colors.white.withOpacity(0.25),
        );
    }
  }

  ThemeData toThemeData() {
    final themeData = ThemeData(
      scaffoldBackgroundColor: isDark ? Colors.black: Colors.white,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(extensions: <ThemeExtension<dynamic>>[this]);

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
        primary: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    bool? isDark,
    GradientColors? gradientColors,
    Color? headerColor,
    Color? transparentContainer,
  }) {
    return AppColors._(
      isDark: isDark ?? this.isDark,
      gradientColors: gradientColors ?? this.gradientColors,
      headerColor: headerColor ?? this.headerColor,
      transparentContainer: transparentContainer ?? this.transparentContainer,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      isDark: t < 0.5 ? isDark : other.isDark,
      gradientColors: gradientColors.lerpTo(other.gradientColors, t),
      headerColor: Color.lerp(headerColor, other.headerColor, t)!,
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
