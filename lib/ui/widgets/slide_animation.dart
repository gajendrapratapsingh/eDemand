import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class AnimationFromRightSide extends StatefulWidget {

  const AnimationFromRightSide({required this.child, required this.delay, super.key});
  final Widget child;
  final int delay;

  @override
  State<AnimationFromRightSide> createState() => _AnimationFromRightSideState();
}

class _AnimationFromRightSideState extends State<AnimationFromRightSide>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.35, 0), end: Offset.zero).animate(curve);

    Timer(Duration(milliseconds: widget.delay), () {
      _animController.forward();
    });
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
