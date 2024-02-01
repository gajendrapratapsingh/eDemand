// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {

  const CustomFlatButton({
    final Key? key,
    this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.fontColor,
    this.fontSize,
    this.innerPadding,
    this.textWidget,
  })  : assert(text == null || textWidget == null),
        super(key: key);
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final String? text;
  final Color? fontColor;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double? innerPadding;
  final Widget? textWidget;

  @override
  Widget build(final BuildContext context) => CustomInkWellContainer(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
        decoration: BoxDecoration(
            color: backgroundColor ?? const Color(0xff343f53),
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf20)),),
        child: Padding(
          padding: EdgeInsetsDirectional.all(innerPadding ?? 8.0),
          child: Center(
              child: textWidget ??
                  Text(
                    text ?? '',
                    style: TextStyle(
                        color: fontColor ?? const Color.fromARGB(255, 250, 250, 250),
                        fontSize: fontSize ?? 14,),
                  ),),
        ),
      ),
    );
}
