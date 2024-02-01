import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {

  const CustomImageContainer(
      { required this.borderRadius, required this.imageURL, required this.height, required this.width, final Key? key,
      this.boxFit,})
      : super(key: key);
  final double height;
  final double width;
  final double borderRadius;
  final String imageURL;
  final BoxFit? boxFit;

  @override
  Widget build(final BuildContext context) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x33000000), offset: Offset(0, 3), blurRadius: 6,)
          ],),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: CustomCachedNetworkImage(
            height: height,
            width: width,
            networkImageUrl: imageURL,
            fit: boxFit,
          ),),
    );
}
