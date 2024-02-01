import 'package:flutter/material.dart';

class CustomInkWellContainer extends StatelessWidget {

  const CustomInkWellContainer(
      { required this.child, final Key? key, this.onTap, this.borderRadius,})
      : super(key: key);
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(final BuildContext context) => InkWell(
      borderRadius: borderRadius,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: child,
    );
}
