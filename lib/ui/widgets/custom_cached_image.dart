import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    required this.networkImageUrl,
    final Key? key,
    this.width,
    this.height,
    this.fit,
  }) : super(key: key);
  final String networkImageUrl;
  final double? width, height;
  final BoxFit? fit;

  @override
  Widget build(final BuildContext context) => networkImageUrl.endsWith('.svg')
      ? SvgPicture.network(
          networkImageUrl,
          fit: BoxFit.fill,
          width: width,
          height: height,
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.accentColor, BlendMode.srcIn),
          placeholderBuilder: (final BuildContext context) => Center(
            child: CustomSvgPicture(
              svgImage: 'place_holder.svg',
              width: width,
              height: height,
              boxFit: BoxFit.contain,
            ),
          ),
        )
      : CachedNetworkImage(
          imageUrl: networkImageUrl,
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.contain,
                ),
              ),
            );
          },
          maxWidthDiskCache: 500,
          maxHeightDiskCache: 500,
          memCacheWidth: 150,
          memCacheHeight: 150,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          errorWidget: (BuildContext context, String url, final error) => Center(
            child: Center(
              child: CustomSvgPicture(
                svgImage: 'noImageFound.svg',
                width: width,
                height: height,
                boxFit: BoxFit.contain,
              ),
            ),
          ),
          placeholder: (final BuildContext context, final String url) => Center(
            child: CustomSvgPicture(
              svgImage: 'place_holder.svg',
              width: width,
              height: height,
              boxFit: BoxFit.cover,
            ),
          ),
        );
}
