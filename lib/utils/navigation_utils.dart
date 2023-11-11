import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension NavigationUtils on BuildContext {
  /// Navigates to [page].
  Future<void> goTo(int page) {
    return read<RootPageController>().animateToPage(page);
  }

  /// Navigates to the next page.
  Future<void> goNext() {
    return read<RootPageController>().nextPage();
  }

  /// Navigates to the previous page.
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

  /// Listeners that are notified before a scroll is executed.
  final List<ValueChanged<int>> _preScrollListeners = [];

  /// Listeners that are notified after a scroll is executed.
  final List<ValueChanged<int>> _postScrollListeners = [];

  void addPreScrollListener(ValueChanged<int> listener) =>
      _preScrollListeners.add(listener);

  void addPostScrollListener(ValueChanged<int> listener) =>
      _postScrollListeners.add(listener);

  void _notifyPreScrollListeners(int nextPage) {
    for (final listener in _preScrollListeners) {
      listener(nextPage);
    }
  }

  void _notifyPostScrollListeners(int nextPage) {
    for (final listener in _postScrollListeners) {
      listener(nextPage);
    }
  }

  @override
  double get page => super.page ?? 0;

  @override
  // PageView's implementation of nextPage and previousPage internally calls
  // animateToPage, so the below implementations of nextPage and previousPage
  // will also notify scroll listeners.
  Future<void> animateToPage(
    int page, {
    Duration duration = _animationDuration,
    Curve curve = _animationCurve,
  }) async {
    if (page < 0 || page >= length) return;

    _notifyPreScrollListeners(page);
    return super
        .animateToPage(page, duration: duration, curve: curve)
        .then((_) => _notifyPostScrollListeners(page));
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
    if (page == 0) return;
    return super.previousPage(duration: duration, curve: curve);
  }
}
