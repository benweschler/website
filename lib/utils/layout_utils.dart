import 'package:flutter/cupertino.dart';

const _wideScreenCutoffWidth = 850;

extension LayoutUtils on BuildContext {
  bool isWideLayout() =>
      MediaQuery.of(this).size.width < _wideScreenCutoffWidth;
}
