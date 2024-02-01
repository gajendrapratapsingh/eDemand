import 'package:flutter/material.dart';

import "../../app/generalImports.dart";

class ShimmerLoadingContainer extends StatelessWidget {

  const ShimmerLoadingContainer({ required this.child, final Key? key}) : super(key: key);
  final Widget child;

  @override
  Widget build(final BuildContext context) => Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.shimmerBaseColor,
      highlightColor: Theme.of(context).colorScheme.shimmerHighlightColor,
      child: child,
    );
}
