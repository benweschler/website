import 'package:flutter/widgets.dart';

/// A convenience class that indefinitely maintains the state of its children
/// until it is disposed of.
class MaintainState extends StatefulWidget {
  final Widget child;

  const MaintainState({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MaintainState> createState() => _MaintainStateState();
}

class _MaintainStateState extends State<MaintainState>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
