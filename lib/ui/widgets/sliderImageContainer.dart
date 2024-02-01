import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class SliderImageContainer extends StatefulWidget {
  final List<SliderImages> sliderImages;

  const SliderImageContainer({Key? key, required this.sliderImages}) : super(key: key);

  @override
  State<SliderImageContainer> createState() => _SliderImageContainerState();
}

class _SliderImageContainerState extends State<SliderImageContainer> {
  int currentSliderImage = 0;

  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  var totalScroll;
  var currentScroll;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: homeScreen['sliderAnimationDuration']), (timer) {
      if (currentSliderImage == widget.sliderImages.length - 1) {
        currentSliderImage = 0;
        _pageController.animateTo(
          0,
          duration: Duration(milliseconds: homeScreen['changeSliderAnimationDuration']),
          curve: Curves.linear,
        );
      } else {
        currentSliderImage += 1;
        _pageController.animateToPage(
          currentSliderImage,
          duration: Duration(milliseconds: homeScreen['changeSliderAnimationDuration']),
          curve: Curves.linear,
        );
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Widget getIndicator({required int index, required BoxConstraints p1}) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: currentSliderImage == index
            ? Theme.of(context).colorScheme.accentColor
            : Theme.of(context).colorScheme.lightGreyColor,
        borderRadius: BorderRadius.circular(borderRadiusOf50),
      ),
      height: 8,
      width: currentSliderImage == index ? 30 : 8,
      child: currentSliderImage == index
          ? LayoutBuilder(
              builder: (context, constraints) {
                //we will get total available scroll with (padding between indicator + indicator size)
                // + added 22, because active indicator extra width of 22
                totalScroll = (widget.sliderImages.length * 18) + 22;
                currentScroll = (index * 18) + 22;
                if (currentScroll >= p1.maxWidth) {
                  final currentScrolls = _scrollController.position.pixels;
                  _scrollController.animateTo(
                    currentScrolls + 5,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeInOut,
                  );
                } else if (index == 0 && _scrollController.position.pixels != 0) {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeInOut,
                  );
                }
                return Container();
              },
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.sliderImages.length,
            onPageChanged: (value) {
              setState(() {
                currentSliderImage = value;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
                child: CustomInkWellContainer(
                  onTap: () {
                    if (widget.sliderImages[index].type == 'Category') {
                      Navigator.pushNamed(
                        context,
                        subCategoryRoute,
                        arguments: {
                          'categoryId': widget.sliderImages[index].typeId,
                          'appBarTitle': widget.sliderImages[index].categoryName,
                          'type': CategoryType.category,
                        },
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadiusOf15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadiusOf15),
                      child: CachedNetworkImage(
                        imageUrl: "${widget.sliderImages[index].sliderImage}",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                        errorWidget: (BuildContext context, String url, final error) => Center(
                          child: Center(
                            child: CustomSvgPicture(
                              svgImage: 'noImageFound.svg',
                              width: 100,
                              height: 100,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                        placeholder: (final BuildContext context, final String url) => Center(
                          child: CustomSvgPicture(
                            svgImage: 'place_holder.svg',
                            width: 100,
                            height: 100,
                            //  boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          width: MediaQuery.sizeOf(context).width,
          child: LayoutBuilder(
            builder: (p0, p1) {
              return Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.sliderImages.length,
                      (index) {
                        return getIndicator(index: index, p1: p1);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
