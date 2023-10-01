import 'package:flutter/foundation.dart';

class PointerMoveNotifier {
  final List<VoidCallback> _mouseUpdateListeners = [];
  final List<VoidCallback> _touchUpdateListeners = [];

  void addMouseListener(VoidCallback listener) =>
      _mouseUpdateListeners.add(listener);

  void addTouchListener(VoidCallback listener) =>
      _touchUpdateListeners.add(listener);

  void notifyMouseUpdate() {
    for (var listener in _mouseUpdateListeners) {
      listener();
    }
  }

  void notifyTouchUpdate() {
    for (var listener in _touchUpdateListeners) {
      listener();
    }
  }
}
