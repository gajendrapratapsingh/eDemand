import '../../app/generalImports.dart';
import 'package:flutter/material.dart';

class DottedBorderWithHint extends StatelessWidget {

  const DottedBorderWithHint(
      { required this.hint, required this.svgImage, required this.radius, required this.needToShowHintText, required this.height, required this.width, final Key? key,
      this.borderColor,})
      : super(key: key);
  final double height;
  final double width;
  final String svgImage;
  final String hint;
  final double radius;
  final Color? borderColor;
  final bool needToShowHintText;

  @override
  Widget build(final BuildContext context) => Stack(alignment: AlignmentDirectional.center, children: [
      SizedBox(
          height: height,
          width: width,
          child: DashedRect(
            color: borderColor ?? Theme.of(context).colorScheme.lightGreyColor,
            strokeWidth: 2,
            gap: 4,
          ),),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CustomSvgPicture(
              svgImage: svgImage, color: Theme.of(context).colorScheme.lightGreyColor,),
          const SizedBox(
            width: 8,
          ),
          if (needToShowHintText)
            Text(
              hint,
              style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor, fontSize: 14),
            )
        ],
      )
    ],);
}
