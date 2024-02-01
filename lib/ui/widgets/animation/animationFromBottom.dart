import 'package:flutter/material.dart';

class AnimationFromBottomSide extends StatefulWidget {

  const AnimationFromBottomSide(
      {required this.child, required this.delay, super.key,});
  final Widget child;
  final int? delay;

  @override
  State<AnimationFromBottomSide> createState() =>
      _AnimationFromBottomSideState();
}

class _AnimationFromBottomSideState extends State<AnimationFromBottomSide>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500),);
    final  curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    } else {
      Future.delayed(Duration(milliseconds: widget.delay!))
          .then((final value) => _animController.forward());
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
}
