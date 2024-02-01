import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomShimmerContainer extends StatelessWidget {

  const CustomShimmerContainer({final Key? key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(final BuildContext context) => Container(
      width: width,
      margin: margin,
      height: height ?? 10,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.shimmerContentColor,
          borderRadius: BorderRadius.circular(borderRadius ?? borderRadiusOf10),),
    );
}
