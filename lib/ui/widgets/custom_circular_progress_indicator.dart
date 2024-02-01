import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {

  const CustomCircularProgressIndicator(
      {final Key? key, this.indicatorColor, this.strokeWidth, this.widthAndHeight,})
      : super(key: key);
  final Color? indicatorColor;
  final double? strokeWidth;
  final double? widthAndHeight;

  @override
  Widget build(final BuildContext context) => Center(
      child: SizedBox(
        height: widthAndHeight ?? 30,
        width: widthAndHeight ?? 30,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 3,
          color: indicatorColor ?? Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
}
