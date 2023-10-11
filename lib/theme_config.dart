import 'package:flutter/foundation.dart';
import 'package:website/style/theme.dart';

class ThemeConfig extends ChangeNotifier {
  ThemeConfig({required Brightness initialBrightness})
      : _themeType = initialBrightness == Brightness.dark
            ? ThemeType.dark
            : ThemeType.light;

  ThemeType _themeType;
  ThemeType get themeType => _themeType;

  // If dark mode was active when it was locked, queue it to be activated when
  // it is unlocked.
  bool _darkModeQueued = false;
  bool _darkModeLocked = false;
  bool get darkModeLocked => _darkModeLocked;

  void lockDarkMode() {
    if(_darkModeLocked) return;

    _darkModeLocked = true;

    if(_themeType == ThemeType.dark) {
      _darkModeQueued = true;
      _themeType = ThemeType.light;
    }

    notifyListeners();
  }

  void unlockDarkMode() {
    if(!_darkModeLocked) return;

    _darkModeLocked = false;

    if(_darkModeQueued && _themeType == ThemeType.light) {
      _themeType = ThemeType.dark;
      _darkModeQueued = false;
    }

    notifyListeners();
  }

  void toggleTheme() {
    if(_darkModeLocked && _themeType == ThemeType.light) return;

    _themeType =
        _themeType == ThemeType.dark ? ThemeType.light : ThemeType.dark;
    notifyListeners();
  }
}
