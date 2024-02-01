import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {

  const CustomRoundedButton({
     required this.buttonTitle, required this.showBorder, required this.widthPercentage, required this.backgroundColor, final Key? key,
    this.child,
    this.maxLines,
    this.borderColor,
    this.elevation,
    this.onTap,
    this.radius,
    this.shadowColor,
    this.height,
    this.titleColor,
    this.fontWeight,
    this.textSize,
  }) : super(key: key);
  final String? buttonTitle;
  final double? height;
  final double widthPercentage;
  final Function? onTap;
  final Color backgroundColor;
  final double? radius;
  final Color? shadowColor;
  final bool showBorder;
  final Color? borderColor;
  final Color? titleColor;
  final double? textSize;
  final FontWeight? fontWeight;
  final double? elevation;
  final int? maxLines;
  final Widget? child;

  @override
  Widget build(final BuildContext context) => Material(
      shadowColor: shadowColor ?? Colors.black54,
      elevation: elevation ?? 0.0,
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius ?? borderRadiusOf10),
      child: CustomInkWellContainer(
        borderRadius: BorderRadius.circular(radius ?? borderRadiusOf10),
        onTap: onTap as void Function()?,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          //
          alignment: Alignment.center,
          height: height ?? 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? borderRadiusOf10),
            border: showBorder
                ? Border.all(
                    color: borderColor ?? Theme.of(context).scaffoldBackgroundColor,
                  )
                : null,
          ),
          width: MediaQuery.sizeOf(context).width * widthPercentage,
          child: Center(
            child: child ??
                Text(
                  '$buttonTitle',
                  maxLines: maxLines ?? 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: textSize ?? 18.0,
                      color: titleColor ?? AppColors.whiteColors,
                      fontWeight: fontWeight ?? FontWeight.normal,),
                ),
          ),
        ),
      ),
    );
}
