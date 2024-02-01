import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class SectionCardForCategoryAndProviderContainer extends StatelessWidget {

  const SectionCardForCategoryAndProviderContainer({
     required this.discount, required this.onTap, required this.imageHeight, required this.imageWidth, required this.cardHeight, required this.title, required this.image, final Key? key,
  }) : super(key: key);
  final String title, image, discount;
  final double imageHeight, imageWidth, cardHeight;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => CustomInkWellContainer(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(top: 10, start: 10),
        height: cardHeight,
        width: imageWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              width: imageWidth,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 5),
                        blurRadius: 6,)
                  ],
                  borderRadius: BorderRadius.circular(borderRadiusOf15),),
              child: Stack(
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: imageWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadiusOf15),
                      child: CustomCachedNetworkImage(
                        height: 100,
                        width: 100,
                        networkImageUrl: image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomCenter,
                    child: Container(
                      width: imageWidth,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(borderRadiusOf15),
                            bottomRight: Radius.circular(borderRadiusOf15),),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.black.withOpacity(0.75),
                          ],
                          stops: const [
                            0.0,
                            1.0,
                          ],
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          tileMode: TileMode.repeated,
                        ),
                      ),
                    ),
                  ),
                  if (discount != "0")
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("$discount${'percentageOff'.translate(context: context)}",
                            style: TextStyle(
                                color: AppColors.whiteColors,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,),),
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,),
                  textAlign: TextAlign.left,),
            ),
          ],
        ),
      ),
    );
}
