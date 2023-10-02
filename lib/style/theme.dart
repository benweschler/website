import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class AppColors extends ThemeExtension<AppColors> {
  final bool isDark;
  final Color headerColor;
  final Color transparentContainer;

  const AppColors._({
    required this.isDark,
    required this.headerColor,
    required this.transparentContainer,
  });

  factory AppColors.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppColors._(
          isDark: false,
          headerColor: Colors.black,
          transparentContainer: Colors.black.withOpacity(0.25),
        );
      case ThemeType.dark:
        return AppColors._(
          isDark: true,
          headerColor: Colors.white,
          transparentContainer: Colors.white.withOpacity(0.25),
        );
    }
  }

  ThemeData toThemeData() {
    final themeData = ThemeData(
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
    Color? headerColor,
    Color? transparentContainer,
  }) {
    return AppColors._(
      isDark: isDark ?? this.isDark,
      headerColor: headerColor ?? this.headerColor,
      transparentContainer: transparentContainer ?? this.transparentContainer,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;

    return AppColors._(
      isDark: t < 0.5 ? isDark : other.isDark,
      headerColor: Color.lerp(headerColor, other.headerColor, t)!,
      transparentContainer: Color.lerp(transparentContainer, other.transparentContainer, t)!,
    );
  }
}
