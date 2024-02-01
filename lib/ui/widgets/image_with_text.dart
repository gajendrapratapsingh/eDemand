import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ImageWithText extends StatelessWidget {

  const ImageWithText(
      { required this.imageContainerHeight, required this.imageContainerWidth, required this.imageRadius, required this.textContainerHeight, required this.textContainerWidth, required this.onTap, required this.imageURL, required this.title, final Key? key,
      this.maxLines,
      this.fontWeight,
      this.darkModeBackgroundColor,
      this.lightModeBackgroundColor,})
      : super(key: key);
  final String imageURL, title;
  final double imageContainerHeight,
      imageContainerWidth,
      imageRadius,
      textContainerHeight,
      textContainerWidth;
  final void Function()? onTap;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? darkModeBackgroundColor;
  final String? lightModeBackgroundColor;

  @override
  Widget build(final BuildContext context) {
    final  darkModeColor =
        darkModeBackgroundColor == "" ? Colors.transparent : darkModeBackgroundColor!.toColor();
    final  lightModeColor =
        lightModeBackgroundColor == "" ? Colors.transparent : lightModeBackgroundColor!.toColor();
    return CustomInkWellContainer(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imageContainerHeight,
            width: imageContainerWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  Theme.of(context).brightness == Brightness.light ? lightModeColor : darkModeColor,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(imageRadius),
                child: CustomCachedNetworkImage(
                  networkImageUrl: imageURL,
                  fit: BoxFit.cover,
                  height: imageContainerHeight,
                  width: imageContainerWidth,
                ),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
                height: textContainerHeight,
                width: textContainerWidth,
                child: Text(title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: fontWeight ?? FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: maxLines ?? 1,
                    textAlign: TextAlign.center,),),
          ),
        ],
      ),
    );
  }
}
