import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension NavigationUtils on BuildContext {
  Future<void> goTo(int page) {
    return read<RootPageController>().animateToPage(page);
  }

  Future<void> goNext() {
    return read<RootPageController>().nextPage();
  }

  Future<void> goPrevious() {
    return read<RootPageController>().previousPage();
  }

  double currentPage() => read<RootPageController>().page;
}

class RootPageController extends PageController {
  /// The number of pages this controller has.
  final int length;

  RootPageController({required this.length});

  static const _animationDuration = Duration(milliseconds: 1200);
  static const _animationCurve = Curves.easeInOutQuart;
  final List<ValueChanged<int>> _scrollListeners = [];

  void addScrollListener(ValueChanged<int> listener) =>
      _scrollListeners.add(listener);

  void removeScrollListener(ValueChanged<int> listener) =>
      _scrollListeners.remove(listener);

  void _notifyScrollListeners(int nextPage) {
    for (final listener in _scrollListeners) {
      listener(nextPage);
    }
  }

  @override
  double get page => super.page ?? 0;

  @override
  Future<void> animateToPage(
    int page, {
    Duration duration = _animationDuration,
    Curve curve = _animationCurve,
  }) async {
    if (page < 0 || page >= length) return;

    // When animating through multiple pages, notify scroll listeners only after
    // animating to the final page so that listeners aren't triggered
    // mid-animation on intervening pages. This is important for listeners that
    // should only be triggered when cross the boundary of a specific page.
    if ((page - this.page).abs() > 1) {
      return super
          .animateToPage(page, duration: duration, curve: curve)
          .then((_) => _notifyScrollListeners(page));
    }

    _notifyScrollListeners(page);
    return super.animateToPage(page, duration: duration, curve: curve);
  }

  @override
  Future<void> nextPage({
    Duration duration = _animationDuration,
    Curve curve = _animationCurve,
  }) async {
    if (page == length - 1) return;
    return super.nextPage(duration: duration, curve: curve);
  }

  @override
  Future<void> previousPage({
    Duration duration = _animationDuration,
    Curve curve = _animationCurve,
  }) async {
    if(page == 0) return;
    return super.previousPage(duration: duration, curve: curve);
  }
}
