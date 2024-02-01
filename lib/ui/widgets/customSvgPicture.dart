import 'package:flutter/material.dart';

import '../../app/generalImports.dart';

class CustomSvgPicture extends StatelessWidget {
  final String svgImage;
  final VoidCallback? onTap;
  final Color? color;
  final double? height;
  final double? width;
  final BoxFit? boxFit;

  const CustomSvgPicture(
      {super.key,
      required this.svgImage,
      this.onTap,
      this.color,
      this.height,
      this.width,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return CustomInkWellContainer(
      onTap: onTap,
      child: SvgPicture.asset(
        UiUtils.getImagePath(svgImage),
        height: height,
        width: width,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        fit: boxFit ?? BoxFit.contain,
      ),
    );
  }
}
