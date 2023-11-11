import 'package:flutter/foundation.dart';

class PointerMoveNotifier {
  final List<VoidCallback> _mouseUpdateListeners = [];
  final List<VoidCallback> _touchUpdateListeners = [];
  final List<VoidCallback> _pointerStopListeners = [];

  void addMouseListener(VoidCallback listener) =>
      _mouseUpdateListeners.add(listener);

  void addTouchListener(VoidCallback listener) =>
      _touchUpdateListeners.add(listener);

  void addPointerStopListener(VoidCallback listener) =>
      _pointerStopListeners.add(listener);

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

  void notifyPointerStop() {
    for (var listener in _pointerStopListeners) {
      listener();
    }
  }
}
