import 'package:flutter/foundation.dart';
import 'package:website/style/theme.dart';

class ThemeConfig extends ChangeNotifier {
  ThemeType _themeType = ThemeType.dark;
  ThemeType get themeType => _themeType;

  void switchTheme() {
    _themeType =
        _themeType == ThemeType.dark ? ThemeType.light : ThemeType.dark;
    notifyListeners();
  }

  ThemeConfig();
}
