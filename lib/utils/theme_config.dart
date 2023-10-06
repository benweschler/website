import 'package:flutter/foundation.dart';
import 'package:website/style/theme.dart';

class ThemeConfig extends ChangeNotifier {
  ThemeType _themeType;

  ThemeType get themeType => _themeType;

  ThemeConfig({required Brightness initialBrightness})
      : _themeType = initialBrightness == Brightness.dark
            ? ThemeType.dark
            : ThemeType.light;

  void switchTheme() {
    _themeType =
        _themeType == ThemeType.dark ? ThemeType.light : ThemeType.dark;
    notifyListeners();
  }
}
