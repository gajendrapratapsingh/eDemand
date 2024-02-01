import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewBookingCardContainer extends StatelessWidget {
  final Booking bookingDetails;
  DateTime? selectedDate;
  dynamic selectedTime;
  String? message;

  NewBookingCardContainer({
    super.key,
    required this.bookingDetails,
  });

  //
  Widget _buildDateAndTimeContainer(
          {required final BuildContext context, required final String time}) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryColor,
            borderRadius: BorderRadius.circular(borderRadiusOf10)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 35,
                width: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadiusOf50),
                        border: Border.all(color: Theme.of(context).colorScheme.lightGreyColor)),
                    padding: const EdgeInsets.all(5),
                    child: CustomSvgPicture(
                      svgImage: 'schedule_timmer.svg',
                      color: Theme.of(context).colorScheme.blackColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'schedule'.translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.lightGreyColor, fontSize: 12),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget _buildAddressContainer({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          CustomSvgPicture(
              svgImage: "current_location.svg",
              width: 20,
              height: 20,
              color: Theme.of(context).colorScheme.accentColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              bookingDetails.address ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceContainer({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          CustomSvgPicture(
              width: 20,
              height: 20,
              svgImage: "discount.svg",
              color: Theme.of(context).colorScheme.accentColor),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
           ( bookingDetails.finalTotal ?? "0").priceFormat(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.accentColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildImageAndTitleRow({
    required final BuildContext context,
  }) =>
      CustomInkWellContainer(
        onTap: () {
          Navigator.pushNamed(
            context,
            providerRoute,
            arguments: {"providerId": bookingDetails.partnerId ?? "0"},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusOf50),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadiusOf50),
                  ),
                  child: CustomCachedNetworkImage(
                      height: 50,
                      width: 50,
                      networkImageUrl: bookingDetails.profileImage ?? "",
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "${"worker".translate(context: context)} ${bookingDetails.companyName}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildStatusAndInvoiceContainer({
    required final BuildContext context,
  }) =>
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildStatusRow(context: context)),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "${"invoiceNumber".translate(context: context)}: ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.lightGreyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.end,
                  ),
                ),
                Text(
                  bookingDetails.invoiceNo ?? "0",
                  style: TextStyle(color: Theme.of(context).colorScheme.accentColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ],
            )),
          ],
        ),
      );

  Widget _buildStatusRow({
    required final BuildContext context,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 30,
            width: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadiusOf10),
              child: CustomSvgPicture(
                svgImage:
                    "${UiUtils.getStatusColorAndImage(context: context, statusVal: bookingDetails.status ?? "")["imageName"]}.svg",
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                color: UiUtils.getStatusColorAndImage(
                        context: context, statusVal: bookingDetails.status ?? "")["color"]
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(borderRadiusOf5),
              ),
              child: Center(
                child: Text(
                  (bookingDetails.status ?? "").translate(context: context).capitalize(),
                  style: TextStyle(
                    color: UiUtils.getStatusColorAndImage(
                        context: context, statusVal: bookingDetails.status ?? "")["color"],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ),
          ),
        ],
      );

//
  Widget _buildServiceListContainer({
    required final BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          bookingDetails.services!.length,
          (final int index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadiusOf10),
                    child: CustomCachedNetworkImage(
                      networkImageUrl: bookingDetails.services![index].image ?? "",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    '${bookingDetails.services![index].serviceTitle}',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.blackColor),
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 9),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadiusOf10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusAndInvoiceContainer(
            context: context,
          ),
          const CustomDivider(
            thickness: 0.5,
          ),
          _buildServiceListContainer(
            context: context,
          ),
          _buildDateAndTimeContainer(
              context: context,
              time:
                  '${bookingDetails.dateOfService.toString().formatDate()}, ${bookingDetails.startingTime.toString().formatTime()}'),
          if (bookingDetails.providerAddress != "" && bookingDetails.addressId != "0")
            _buildAddressContainer(context: context),
          _buildPriceContainer(context: context),
          const CustomDivider(
            thickness: 0.5,
          ),
          _buildImageAndTitleRow(
            context: context,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
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
                              bookingId: bookingDetails.id ?? "0",
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
                                  advanceBookingDays:
                                      bookingDetails.providerAdvanceBookingDays.toString(),
                                  providerId: bookingDetails.partnerId.toString(),
                                  selectedDate: selectedDate,
                                  selectedTime: selectedTime,
                                  orderId: bookingDetails.id ?? "0",
                                ),
                              ),
                            ).then((value) {
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
                            });
                          })),
              ],
            ),
          ),
          if (bookingDetails.status == "completed") ...[
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10,
              ),
              child: Row(
                children: [
                  if (bookingDetails.isReorderAllowed == "1") ...[
                    Expanded(
                      child: ReOrderButton(
                        bookingDetails: bookingDetails,
                        isReorderFrom: "bookings",
                        bookingId: bookingDetails.id ?? "0",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  Expanded(
                    child: DownloadInvoiceButton(bookingId: bookingDetails.id ?? "0"),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
