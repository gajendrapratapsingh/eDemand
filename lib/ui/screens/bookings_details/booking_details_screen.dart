// ignore_for_file: use_build_context_synchronously

import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/utils/checkURLType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BookingDetails extends StatelessWidget {
  //

  Booking bookingDetails;

  BookingDetails({final Key? key, required this.bookingDetails}) : super(key: key);

  static Route route(final RouteSettings routeSettings) {
    final Map parameters = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final BuildContext context) => BookingDetails(
        bookingDetails: parameters["bookingDetails"],
      ),
    );
  }

  DateTime? selectedDate;
  dynamic selectedTime;
  String? message;

  //
  Widget _buildImageWithTitleAndSubtitleTile({
    required final BuildContext context,
    required final String title,
    required final String subTitle,
    required final String svgImage,
    final Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap?.call,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: CustomSvgPicture(
                      svgImage: svgImage,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.lightGreyColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildImageAndTitleRow({
    required final BuildContext context,
    required final String providerName,
    required final String providerImageUrl,
    required final String invoiceNumber,
    required final String price,
  }) =>
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusOf50),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                ),
                child: CustomCachedNetworkImage(
                    height: 50, width: 50, networkImageUrl: providerImageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: _buildServiceNameColumn(
                context: context,
                providerName: providerName,
                invoiceNumber: invoiceNumber,
                price: price,
              ),
            ),
          ],
        ),
      );

  Widget _buildServiceNameColumn({
    required final BuildContext context,
    required final String providerName,
    required final String invoiceNumber,
    required final String price,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            providerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.blackColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${"invoiceNumber".translate(context: context)}: ",
                style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
              ),
              Text(
                invoiceNumber,
                style: TextStyle(color: Theme.of(context).colorScheme.accentColor),
              ),
              const Spacer(),
              Text(
                price.priceFormat(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            ],
          )
        ],
      );

  Widget _getTitleAndValue({
    required final BuildContext context,
    required final String title,
    required final String value,
    final Color? color,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title.translate(context: context).capitalize(),
              style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              height: 30,
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: (color ?? UiUtils.getStatusColor(context: context, statusVal: value))
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(borderRadiusOf5),
                border: Border.all(
                  color: color ?? UiUtils.getStatusColor(context: context, statusVal: value),
                ),
              ),
              child: Center(
                child: Text(
                  value.translate(context: context),
                  style: TextStyle(
                    color: color ?? UiUtils.getStatusColor(context: context, statusVal: value),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

//
  Widget _buildServiceListContainer({
    required final String bookingStatus,
    required final List<BookedService> servicesList,
    required final BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(servicesList.length, (int index) {
          //
          final double totalPriceOfService = double.parse(servicesList[index].quantity!) *
              double.parse(
                servicesList[index].discountPrice != '0'
                    ? servicesList[index].discountPrice!
                    : servicesList[index].price!,
              );
          //
          final int serviceRating = int.parse(
            (servicesList[index].rating ?? 0).toString().isNotEmpty
                ? '0'
                : servicesList[index].rating ?? '0',
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${servicesList[index].serviceTitle} ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${servicesList[index].quantity} x ${(servicesList[index].discountPrice != "0" ? servicesList[index].discountPrice.toString() : servicesList[index].price.toString()).priceFormat()}",
                      style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
                    ),
                    const Spacer(),
                    Text(
                      totalPriceOfService.toString().priceFormat(),
                      style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
                    ),
                  ],
                ),
                if (bookingStatus == "completed")
                  Row(
                    children: [
                      Text(
                        'rate'.translate(context: context),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.blackColor,
                        ),
                      ),
                      CustomInkWellContainer(
                        onTap: () {
                          UiUtils.showBottomSheet(
                            enableDrag: true,
                            context: context,
                            child: BlocProvider<SubmitReviewCubit>(
                              create: (final BuildContext context) =>
                                  SubmitReviewCubit(bookingRepository: BookingRepository()),
                              child: RatingBottomSheet(
                                reviewComment: servicesList[index].comment!,
                                ratingStar: serviceRating,
                                serviceID: servicesList[index].serviceId!,
                                serviceName: servicesList[index].serviceTitle ?? "",
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: List.generate(
                            5,
                            (final int serviceIndex) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              width: 30,
                              height: 20,
                              decoration: BoxDecoration(
                                color: serviceRating == serviceIndex + 1
                                    ? Theme.of(context).colorScheme.accentColor
                                    : null,
                                borderRadius: BorderRadius.circular(borderRadiusOf5),
                                border:
                                    Border.all(color: Theme.of(context).colorScheme.accentColor),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${serviceIndex + 1}',
                                      style: TextStyle(
                                        color: serviceRating == serviceIndex + 1
                                            ? AppColors.whiteColors
                                            : Theme.of(context).colorScheme.lightGreyColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 15,
                                      color: serviceRating == serviceIndex + 1
                                          ? AppColors.whiteColors
                                          : Theme.of(context).colorScheme.lightGreyColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                const CustomDivider(),
              ],
            ),
          );
        }),
      );

  //
  Padding _getPriceSectionTile({
    required final BuildContext context,
    required final String heading,
    required final String subHeading,
    required final Color textColor,
    required final double fontSize,
    final FontWeight? fontWeight,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Text(
              heading,
              style: TextStyle(color: textColor, fontWeight: fontWeight),
            ),
            const Spacer(),
            Text(
              subHeading,
              style: TextStyle(color: textColor, fontWeight: fontWeight),
            ),
          ],
        ),
      );

//
  Padding _buildPriceSection({
    required final BuildContext context,
    required final String subTotal,
    required final String taxAmount,
    required final String visitingCharge,
    required final String promoCodeAmount,
    required final String promoCodeName,
    required final String totalAmount,
    required final bool isAtStoreOptionSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          _getPriceSectionTile(
            context: context,
            fontSize: 14,
            heading: 'subTotal'.translate(context: context),
            subHeading: subTotal.priceFormat(),
            textColor: Theme.of(context).colorScheme.blackColor,
          ),
          if (promoCodeName != "" && promoCodeAmount != "")
            _getPriceSectionTile(
              context: context,
              fontSize: 14,
              heading: "${"promoCode".translate(context: context)} ($promoCodeName)",
              subHeading: promoCodeAmount.priceFormat(),
              textColor: Theme.of(context).colorScheme.blackColor,
            ),
          if (taxAmount != "")
            _getPriceSectionTile(
              context: context,
              fontSize: 14,
              heading: 'tax'.translate(context: context),
              subHeading: taxAmount.priceFormat(),
              textColor: Theme.of(context).colorScheme.blackColor,
            ),
          if (visitingCharge != '0' &&
              visitingCharge != "" &&
              visitingCharge != 'null' &&
              !isAtStoreOptionSelected)
            _getPriceSectionTile(
              context: context,
              fontSize: 14,
              heading: 'visitingCharge'.translate(context: context),
              subHeading: visitingCharge.priceFormat(),
              textColor: Theme.of(context).colorScheme.blackColor,
            ),
          _getPriceSectionTile(
            context: context,
            fontSize: 35,
            heading: 'totalAmount'.translate(context: context),
            subHeading: totalAmount.priceFormat(),
            textColor: Theme.of(context).colorScheme.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  //
  Widget uploadedProofWidget({
    required final BuildContext context,
    required final String title,
    required final List<dynamic> proofData,
  }) =>
      Container(
        color: Theme.of(context).colorScheme.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.translate(context: context),
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: List.generate(
                      proofData.length,
                      (final int index) => Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsetsDirectional.only(end: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.lightGreyColor),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              imagePreview,
                              arguments: {
                                "startFrom": index,
                                "isReviewType": false,
                                "dataURL": proofData,
                              },
                            ).then((Object? value) {
                              //locked in portrait mode only
                              SystemChrome.setPreferredOrientations(
                                [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
                              );
                            });
                          },
                          child: UrlTypeHelper.getType(proofData[index]) == UrlType.image
                              ? CustomCachedNetworkImage(
                                  networkImageUrl: proofData[index],
                                  height: 50,
                                  width: 50,
                                )
                              : UrlTypeHelper.getType(proofData[index]) == UrlType.video
                                  ? Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Theme.of(context).colorScheme.accentColor,
                                      ),
                                    )
                                  : Container(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

//
  Stack getBookingDetailsData({required final BuildContext context}) {
    String scheduledTime =
        "${bookingDetails.dateOfService!.formatDate()}, ${bookingDetails.startingTime!.formatTime()}-${bookingDetails.endingTime!.formatTime()}";
    if (bookingDetails.multipleDaysBooking!.isNotEmpty) {
      String currentDate = "";
      for (int i = 0; i < bookingDetails.multipleDaysBooking!.length; i++) {
        currentDate =
            "\n${bookingDetails.multipleDaysBooking![i].multipleDayDateOfService.toString().formatDate()},${bookingDetails.multipleDaysBooking![i].multipleDayStartingTime.toString().formatTime()}-${bookingDetails.multipleDaysBooking![i].multipleEndingTime.toString().formatTime()}";
      }
      scheduledTime = scheduledTime + currentDate;
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: getScrollViewBottomPadding(context),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryColor,
                borderRadius: BorderRadius.circular(borderRadiusOf10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageAndTitleRow(
                    context: context,
                    providerName: bookingDetails.companyName!,
                    invoiceNumber: bookingDetails.invoiceNo!,
                    providerImageUrl: bookingDetails.profileImage!,
                    price: bookingDetails.finalTotal!,
                  ),
                  const CustomDivider(
                    thickness: 0.8,
                  ),

                  //
                  if (context.read<SystemSettingCubit>().checkOTPSystemEnableOrNot()) ...[
                    _getTitleAndValue(
                      context: context,
                      title: "otp",
                      value: bookingDetails.otp ?? "--",
                      color: AppColors.ratingStarColor,
                    ),
                    const SizedBox(height: 10),
                  ],

                  _getTitleAndValue(
                    context: context,
                    title: "status",
                    value: bookingDetails.status!,
                  ),
                  const SizedBox(height: 10),
                  _getTitleAndValue(
                      context: context,
                      title: "bookedAt",
                      value: (bookingDetails.addressId == "0" ? "atStore" : "atHome")
                          .translate(context: context),
                      color: Theme.of(context).colorScheme.blackColor),
                  _buildImageWithTitleAndSubtitleTile(
                    context: context,
                    title: scheduledTime,
                    svgImage: 'schedule_timmer.svg',
                    subTitle: "schedule".translate(context: context),
                  ),
                  _buildImageWithTitleAndSubtitleTile(
                      context: context,
                      title: bookingDetails.addressId != "0"
                          ? bookingDetails.address ?? ""
                          : "${bookingDetails.providerAddress}\n${bookingDetails.providerNumber}",
                      svgImage: 'address.svg',
                      subTitle: (bookingDetails.addressId == "0" ? "storeAddress" : "yourAddress")
                          .translate(context: context),
                      onTap: () async {
                        //bookingDetails.addressId =="0" means booking booked as At store option
                        if (bookingDetails.addressId == "0") {
                          try {
                            await launchUrl(
                              Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=${bookingDetails.providerLatitude},${bookingDetails.providerLongitude}',
                              ),
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            UiUtils.showMessage(
                              context,
                              'somethingWentWrong'.translate(context: context),
                              MessageType.error,
                            );
                          }
                        }
                      }),
                  if (bookingDetails.remarks != "")
                    _buildImageWithTitleAndSubtitleTile(
                      context: context,
                      title: bookingDetails.remarks!,
                      svgImage: 'instrucstion.svg',
                      subTitle: "notesLbl".translate(context: context),
                    ),
                  const CustomDivider(
                    thickness: 0.8,
                  ),

                  if (bookingDetails.workStartedProof!.isNotEmpty) ...[
                    uploadedProofWidget(
                      context: context,
                      title: "workStartedProof",
                      proofData: bookingDetails.workStartedProof!,
                    ),
                    const CustomDivider(
                      thickness: 0.8,
                    ),
                  ],
                  if (bookingDetails.workCompletedProof!.isNotEmpty) ...[
                    uploadedProofWidget(
                      context: context,
                      title: "workCompletedProof",
                      proofData: bookingDetails.workCompletedProof!,
                    ),
                    const CustomDivider(
                      thickness: 0.8,
                    ),
                  ],
                  _buildServiceListContainer(
                    bookingStatus: bookingDetails.status!,
                    servicesList: bookingDetails.services!,
                    context: context,
                  ),

                  _buildPriceSection(
                      context: context,
                      totalAmount: bookingDetails.finalTotal!,
                      promoCodeAmount: bookingDetails.promoDiscount!,
                      promoCodeName: bookingDetails.promoCode!,
                      subTotal: (double.parse(bookingDetails.total!.replaceAll(",", "")) -
                              double.parse(
                                bookingDetails.taxAmount!.replaceAll(",", ""),
                              ))
                          .toString(),
                      taxAmount: bookingDetails.taxAmount!,
                      visitingCharge: bookingDetails.visitingCharges!,
                      isAtStoreOptionSelected: bookingDetails.addressId == "0"),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            if (bookingDetails.isCancelable == "1" && bookingDetails.status != "cancelled") ...[
              Expanded(
                child: CancelAndRescheduleButton(
                  bookingId: bookingDetails.id ?? "0",
                  buttonName: "cancelBooking",
                  onButtonTap: () {
                    context.read<ChangeBookingStatusCubit>().changeBookingStatus(
                          pressedButtonName: "cancelBooking",
                          bookingStatus: 'cancelled',
                          bookingId: bookingDetails.id!,
                        );
                  },
                ),
              ),
              if (bookingDetails.status == "awaiting" || bookingDetails.status == "confirmed")
                const SizedBox(
                  width: 10,
                )
            ],
            if (bookingDetails.status == "awaiting" || bookingDetails.status == "confirmed")
              Expanded(
                child: CancelAndRescheduleButton(
                  bookingId: bookingDetails.id ?? "0",
                  buttonName: "reschedule",
                  onButtonTap: () {
                    UiUtils.showBottomSheet(
                      enableDrag: true,
                      context: context,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider<ValidateCustomTimeCubit>(
                            create: (context) =>
                                ValidateCustomTimeCubit(cartRepository: CartRepository()),
                          ),
                          BlocProvider(
                            create: (context) => TimeSlotCubit(CartRepository()),
                          )
                        ],
                        child: CalenderBottomSheet(
                          advanceBookingDays: bookingDetails.providerAdvanceBookingDays.toString(),
                          providerId: bookingDetails.partnerId.toString(),
                          selectedDate: selectedDate,
                          selectedTime: selectedTime,
                          orderId: bookingDetails.id.toString(),
                        ),
                      ),
                    ).then(
                      (value) {
                        //
                        selectedDate = DateTime.parse(DateFormat("yyyy-MM-dd")
                            .format(DateTime.parse("${value['selectedDate']}")));
                        //
                        selectedTime = value['selectedTime'];
                        //
                        message = value['message'];
                        //
                        if (selectedTime != null && selectedTime != null) {
                          context.read<ChangeBookingStatusCubit>().changeBookingStatus(
                              pressedButtonName: "reschedule",
                              bookingStatus: 'rescheduled',
                              bookingId: bookingDetails.id!,
                              selectedTime: selectedTime.toString(),
                              selectedDate: selectedDate.toString());
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        if (bookingDetails.status == "completed") ...[
          Row(
            children: [
              if (bookingDetails.isReorderAllowed == "1") ...[
                Expanded(
                  child: ReOrderButton(
                    bookingDetails: bookingDetails,
                    isReorderFrom: "bookingDetails",
                    bookingId: bookingDetails.id ?? "0",
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
              Expanded(
                child: DownloadInvoiceButton(bookingId: bookingDetails.id ?? "0"),
              ),
            ],
          )
        ]
      ],
    );
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: 'bookingInformation'.translate(context: context),
        ),
        body: BlocListener<ChangeBookingStatusCubit, ChangeBookingStatusState>(
          listener: (context, state) {
            if (state is ChangeBookingStatusFailure) {
              UiUtils.showMessage(context,
                  state.errorMessage.toString().translate(context: context), MessageType.error);
            } else if (state is ChangeBookingStatusSuccess) {
              UiUtils.showMessage(context, state.message, MessageType.success);
              //
              context
                  .read<BookingCubit>()
                  .updateBookingDataLocally(latestBookingData: state.bookingData);

              bookingDetails = state.bookingData;
            }
          },
          child: BlocBuilder<BookingCubit, BookingState>(
            builder: (final BuildContext context, final BookingState state) {
              if (state is BookingFetchSuccess) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                  child: getBookingDetailsData(
                    context: context,
                  ),
                );
              }
              return ErrorContainer(errorMessage: 'somethingWentWrong'.translate(context: context));
            },
          ),
        ),
      );
}
