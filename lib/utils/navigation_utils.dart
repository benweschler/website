import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension NavigationUtils on BuildContext {
  Future<void> jumpTo(int page) {
    return read<RootPageController>().animateToPage(page);
  }

  Future<void> jumpNext() {
    return read<RootPageController>().nextPage();
  }

  Future<void> jumpPrevious() {
    return read<RootPageController>().previousPage();
  }

  double currentPage() => read<RootPageController>().page;
}

class RootPageController extends PageController {
  static const _animationDuration = Duration(milliseconds: 1200);
  static const _animationCurve = Curves.easeInOutQuart;

  @override
  double get page => super.page ?? 0;

  @override
  Future<void> animateToPage(int page,
      {Duration duration = _animationDuration, Curve curve = _animationCurve}) {
    return super.animateToPage(page, duration: duration, curve: curve);
  }

  @override
  Future<void> nextPage(
      {Duration duration = _animationDuration, Curve curve = _animationCurve}) {
    return super.nextPage(duration: duration, curve: curve);
  }

  @override
  Future<void> previousPage(
      {Duration duration = _animationDuration, Curve curve = _animationCurve}) {
    return super.previousPage(duration: duration, curve: curve);
  }
}
