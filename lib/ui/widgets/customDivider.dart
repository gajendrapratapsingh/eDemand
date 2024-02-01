import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final double? endIndent;
  final double? indent;
  final double? height;

  const CustomDivider(
      {super.key, this.color, this.thickness, this.endIndent, this.indent, this.height});

  @override
  Widget build(BuildContext context) {
    return  Divider(
      color: color,
      height: height,
      indent: indent,
      endIndent: endIndent,
      thickness: thickness,
    );
  }
}
