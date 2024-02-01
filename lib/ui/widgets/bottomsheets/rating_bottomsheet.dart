import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class RatingBottomSheet extends StatefulWidget {
  final String serviceID;
  final String serviceName;
  final int? ratingStar;
  final String reviewComment;

  const RatingBottomSheet({
    Key? key,
    required this.serviceID,
    required this.serviceName,
    this.ratingStar,
    required this.reviewComment,
  }) : super(key: key);

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> with ChangeNotifier {
  // comment controller
  final TextEditingController reviewController = TextEditingController();

  int? selectedRating;

//image picker for review images
  final ImagePicker imagePicker = ImagePicker();
  ValueNotifier<List<XFile?>> reviewImages = ValueNotifier([]);

  Future<void> selectReviewImage() async {
    final List<XFile> listOfSelectedImage = await imagePicker.pickMultiImage();
    if (listOfSelectedImage.isNotEmpty) {
      reviewImages.value = listOfSelectedImage;
    }
  }

  Widget _getHeading({required String heading}) {
    return Text(
      heading,
      style: TextStyle(
        color: Theme.of(context).colorScheme.blackColor,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        fontSize: 20.0,
      ),
      textAlign: TextAlign.start,
    );
  }

  @override
  void dispose() {
    reviewImages.dispose();
    reviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.reviewComment != "") {
      reviewController.text = widget.reviewComment;
    }
    if (widget.ratingStar != null) {
      selectedRating = widget.ratingStar! - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 15),
      color: Theme.of(context).colorScheme.primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryColor,
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(borderRadiusOf10),
                topEnd: Radius.circular(borderRadiusOf10),
              ),
            ),
            child: _getHeading(heading: "reviewAndRating".translate(context: context)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(bottom: 10, start: 5, top: 5),
                  child: Text(
                    widget.serviceName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: List.generate(5, (index) {
                      return CustomInkWellContainer(
                        onTap: () {
                          selectedRating = index;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          width: 40,
                          height: 25,
                          decoration: BoxDecoration(
                            color: selectedRating == index
                                ? Theme.of(context).colorScheme.accentColor
                                : null,
                            borderRadius: BorderRadius.circular(borderRadiusOf5),
                            border: Border.all(color: Theme.of(context).colorScheme.accentColor),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: selectedRating == index
                                        ? AppColors.whiteColors
                                        : Theme.of(context).colorScheme.lightGreyColor,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.star_outlined,
                                  size: 15,
                                  color: selectedRating == index
                                      ? AppColors.whiteColors
                                      : Theme.of(context).colorScheme.lightGreyColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  height: 100,
                  child: TextField(
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.blackColor),
                    maxLines: 5,
                    textAlign: TextAlign.start,
                    controller: reviewController,
                    cursorColor: Theme.of(context).colorScheme.blackColor,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      filled: false,
                      fillColor: Theme.of(context).colorScheme.secondaryColor,
                      hintText:
                          "${"writeReview".translate(context: context)} for ${widget.serviceName}",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.lightGreyColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                        borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                        borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf5)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                        borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf5)),
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: reviewImages,
                  builder: (context, List<XFile?> value, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      //if images is there then we will enable scroll
                      physics: value.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: selectReviewImage,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 15),
                              child: DottedBorderWithHint(
                                width: value.isEmpty ? MediaQuery.sizeOf(context).width - 30 : 100,
                                height: 100,
                                radius: 5,
                                borderColor: Theme.of(context).colorScheme.accentColor,
                                hint: "chooseImage".translate(context: context),
                                svgImage: "image_icon.svg",
                                needToShowHintText: value.isEmpty,
                              ),
                            ),
                          ),
                          if (value.isNotEmpty)
                            Row(
                              children: List.generate(
                                value.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.blackColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(child: Image.file(File(value[index]!.path))),
                                      Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: InkWell(
                                          onTap: () async {
                                            reviewImages.value.removeAt(index);

                                            reviewImages.notifyListeners();
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .blackColor
                                                .withOpacity(0.4),
                                            child: const Center(
                                              child: Icon(
                                                Icons.clear_rounded,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    );
                  },
                ),
                BlocConsumer<SubmitReviewCubit, SubmitReviewState>(
                  listener: (context, state) async {
                    if (state is SubmitReviewSuccess) {
                      UiUtils.showMessage(
                        context,
                        "reviewSubmittedSuccessfully".translate(context: context),
                        MessageType.success,
                      );
                      //
                      // get updated rating
                      /*context.read<BookingCubit>().fetchBookingDetails(
                            status: 'completed', isLoadingMore: true);*/
                      //
                      Navigator.pop(context);
                    } else if (state is SubmitReviewFailure) {
                      UiUtils.showMessage(
                        context,
                        state.errorMessage.translate(context: context),
                        MessageType.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    Widget? child;
                    if (state is SubmitReviewInProgress) {
                      child = CircularProgressIndicator(color: AppColors.whiteColors);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CustomRoundedButton(
                        onTap: () {
                          if (selectedRating == null) {
                            UiUtils.showMessage(
                              context,
                              "pleaseGiveRating".translate(context: context),
                              MessageType.warning,
                            );
                            return;
                          }

                          context.read<SubmitReviewCubit>().submitReview(
                                serviceId: widget.serviceID,
                                ratingStar: (selectedRating! + 1).toString(),
                                reviewComment: reviewController.text.trim().toString(),
                                reviewImages: reviewImages.value,
                              );
                        },
                        widthPercentage: 1,
                        backgroundColor: Theme.of(context).colorScheme.accentColor,
                        buttonTitle: "submitReview".translate(context: context),
                        showBorder: false,
                        child: child,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
