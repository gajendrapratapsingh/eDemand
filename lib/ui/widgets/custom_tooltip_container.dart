import 'package:flutter/material.dart';

class CustomToolTip extends StatelessWidget {

  const CustomToolTip(
      { required this.toolTipMessage, required this.child, final Key? key,})
      : super(key: key);
  final String toolTipMessage;
  final Widget child;

  @override
  Widget build(final BuildContext context) => Tooltip(
      message: toolTipMessage,
      triggerMode: TooltipTriggerMode.longPress,
      child: child,
    );
}
