import 'package:flutter/material.dart';

class CustomTweenAnimation extends StatelessWidget {

  const CustomTweenAnimation({ required this.curve, required this.builder, required this.beginValue, required this.endValue, final Key? key, this.durationInSeconds}) : super(key: key);
  final ValueWidgetBuilder<double> builder;
  final int? durationInSeconds;
  final double beginValue;
  final double endValue;
  final Curve curve;

  @override
  Widget build(final BuildContext context) => TweenAnimationBuilder(
      tween: Tween<double>(begin: beginValue, end: endValue),
      curve: curve,
      duration: Duration(seconds: durationInSeconds ?? 2),
      builder: ( BuildContext context,Object?  value, Widget? child) => builder(context, double.parse(value.toString()), child),
    );
}
