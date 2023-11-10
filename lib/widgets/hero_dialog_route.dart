import 'package:flutter/widgets.dart';

/// A dialog route that mimics showDialog when pushed. This is required since
/// showDialog does not support [Hero].
class HeroDialogRoute<T> extends PageRoute<T> {
  final Widget child;

  HeroDialogRoute({required this.child}) : super();

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  // Black with 54% opacity, which is the mask color behind dialogs used in
  // Material Design.
  Color get barrierColor => const Color(0x8A000000);

  @override
  String? get barrierLabel => 'Full screen app preview';

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    return child;
  }
}
