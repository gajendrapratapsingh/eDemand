import 'package:intl/intl.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/widgets/customVideoPlayer/playVideoScreen.dart';
import 'package:e_demand/utils/checkURLType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ImagePreview extends StatefulWidget {

  const ImagePreview(
      { required this.isReviewType, required this.dataURL, required this.reviewDetails, required this.startFrom, final Key? key,})
      : super(key: key);
  final Reviews? reviewDetails;
  final int startFrom;
  final bool isReviewType;
  final List<dynamic> dataURL;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();

  static Route route(final RouteSettings settings) {
    final  arguments = settings.arguments as Map;
    return CupertinoPageRoute(builder: (final context) => ImagePreview(
        reviewDetails: arguments["reviewDetails"] ?? Reviews(),
        startFrom: arguments["startFrom"],
        isReviewType: arguments["isReviewType"],
        dataURL: arguments["dataURL"],
      ),);
  }
}

class _ImagePreviewState extends State<ImagePreview> with TickerProviderStateMixin {
  //
  ValueNotifier<bool> isShowData = ValueNotifier(true);

//
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> opacityAnimation = Tween<double>(
    begin: 1,
    end: 0,
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.linear,
  ),);

  //
  late final PageController _pageController = PageController(initialPage: widget.startFrom);

  @override
  void dispose() {
    isShowData.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.dataURL.length,
            itemBuilder: (final BuildContext  context, int  index) => InkWell(
                  onTap: () {
                    if (widget.isReviewType) {
                      isShowData.value = !isShowData.value;

                      if (isShowData.value) {
                        animationController.forward();
                      } else {
                        animationController.reverse();
                      }
                    }
                  },
                  child: UrlTypeHelper.getType(widget.dataURL[index]) == UrlType.image
                      ? CustomCachedNetworkImage(networkImageUrl: widget.dataURL[index],
                  fit: BoxFit.contain,
                  )
                      : PlayVideoScreen(
                          videoURL: widget.dataURL[index],
                        ),),
          ),
          PositionedDirectional(
            start: 10,
            top: 10,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (final BuildContext  context, Widget? child) => Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                      height: 35,
                      width: 35,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.accentColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(borderRadiusOf10),),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: SvgPicture.asset(

                                    context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                                        ? Directionality.of(context)
                                                .toString()
                                                .contains(TextDirection.RTL.value.toLowerCase())
                                            ? UiUtils.getImagePath("back_arrow_dark_ltr.svg")
                                            : UiUtils.getImagePath("back_arrow_dark.svg")
                                        : Directionality.of(context)
                                                .toString()
                                                .contains(TextDirection.RTL.value.toLowerCase())
                                            ? UiUtils.getImagePath("back_arrow_light_ltr.svg")
                                            : UiUtils.getImagePath("back_arrow_light.svg"),
                                height: 25,
                                width: 25,),
                          ),),),),
            ),
          ),
          if (widget.isReviewType) ...[
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (final BuildContext     context, Widget?  child) => Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    constraints:
                        BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3),
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.blackColor.withOpacity(0.35),
                            offset: const Offset(0, 0.75),
                            spreadRadius: 5,
                            blurRadius: 25,)
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          minRadius: 15,
                          maxRadius: 20,
                          child: CustomCachedNetworkImage(
                              networkImageUrl: widget.reviewDetails!.profileImage ?? '',),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SingleChildScrollView(
                          clipBehavior: Clip.none,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.reviewDetails!.comment ?? '',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondaryColor,
                                    fontSize: 14,),
                              ),
                              StarRating(
                                  rating: double.parse(widget.reviewDetails!.rating!),
                                  onRatingChanged: (final double rating) => rating,),
                              Text(
                                "${widget.reviewDetails!.userName ?? ""}, ${widget.reviewDetails!.ratedOn!.convertToAgo(context: context)}",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondaryColor,
                                    fontSize: 12,),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
