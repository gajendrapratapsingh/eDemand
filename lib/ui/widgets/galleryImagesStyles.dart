import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/widgets/bottomsheets/ServiceDetails/serviceImagesList.dart';
import 'package:flutter/material.dart';

class GalleryImagesStyles extends StatelessWidget {
  final List<String> imagesList;

  const GalleryImagesStyles({super.key, required this.imagesList});

  Widget getGalleryImage(
      {required BuildContext context,
      required int imageIndex,
      required bool navigateToPreviewOnTap}) {
    return CustomInkWellContainer(
      onTap: navigateToPreviewOnTap
          ? () {
              Navigator.pushNamed(
                context,
                imagePreview,
                arguments: {
                  "startFrom": imageIndex,
                  "isReviewType": false,
                  "dataURL": imagesList,
                },
              );
            }
          : () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadiusOf15),
        child: CachedNetworkImage(
          imageUrl: imagesList[imageIndex],
          fit: BoxFit.cover,
          errorWidget: (BuildContext context, String url, final error) => Center(
            child: Center(
              child: CustomSvgPicture(
                svgImage: 'noImageFound.svg',
                boxFit: BoxFit.contain,
                width: 100,
                height: 100,
              ),
            ),
          ),
          placeholder: (final BuildContext context, final String url) => Center(
            child: CustomSvgPicture(
              svgImage: 'place_holder.svg',
              boxFit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }

  Widget gallerySectionStyle1({required BuildContext context}) {
    return Row(
      children: List.generate(
        imagesList.length,
        (index) => Expanded(
          child: Container(
            height: 180,
            margin: EdgeInsetsDirectional.only(
              end: imagesList.length - 1 != index ? 10 : 0,
            ),
            child: getGalleryImage(
              context: context,
              imageIndex: index,
              navigateToPreviewOnTap: true,
            ),
          ),
        ),
      ),
    );
  }

  Widget gallerySectionStyle2({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 180,
            child: getGalleryImage(
              context: context,
              imageIndex: 0,
              navigateToPreviewOnTap: true,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 85,
                width: double.infinity,
                child: getGalleryImage(
                  context: context,
                  imageIndex: 1,
                  navigateToPreviewOnTap: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 85,
                child: getGalleryImage(
                  context: context,
                  imageIndex: 2,
                  navigateToPreviewOnTap: true,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget gallerySectionStyle3({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 175,
                width: double.infinity,
                child: getGalleryImage(
                  context: context,
                  imageIndex: 0,
                  navigateToPreviewOnTap: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 90,
                child: getGalleryImage(
                  context: context,
                  imageIndex: 1,
                  navigateToPreviewOnTap: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 90,
                width: double.infinity,
                child: getGalleryImage(
                  context: context,
                  imageIndex: 2,
                  navigateToPreviewOnTap: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 175,
                    child: getGalleryImage(
                      context: context,
                      imageIndex: 3,
                      navigateToPreviewOnTap:imagesList.length > 4 ? false :true,
                    ),
                  ),
                  if (imagesList.length > 4)
                    CustomInkWellContainer(
                      onTap: () {
                        UiUtils.showBottomSheet(
                          context: context,
                          enableDrag: true,
                          isScrollControlled: true,
                          useSafeArea: true,
                          child: ServiceImagesList(
                            imageList: imagesList,
                          ),
                        );
                      },
                      child: Container(
                        color: Theme.of(context).colorScheme.secondaryColor.withOpacity(0.7),
                        height: 175,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.panorama,
                                color: Theme.of(context).colorScheme.blackColor,
                                size: 25,
                              ),
                              Text(
                                'seeAll'.translate(context: context),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return imagesList.length <= 2
        ? gallerySectionStyle1(context: context)
        : imagesList.length <= 3
            ? gallerySectionStyle2(context: context)
            : gallerySectionStyle3(context: context);
  }
}
