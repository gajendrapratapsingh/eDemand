import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/screens/bookings_details/widgets/bookingCardContainer.dart';
import 'package:e_demand/ui/screens/bookings_details/widgets/newBookingCardContainer.dart';
import 'package:flutter/material.dart';

class BookingsList extends StatefulWidget {
  final String selectedStatus;
  final ScrollController scrollController;

  const BookingsList({super.key, required this.selectedStatus, required this.scrollController});

  @override
  State<BookingsList> createState() => _BookingsListState();
}

class _BookingsListState extends State<BookingsList> {
  //
  //
  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
    widget.scrollController.addListener(() {
      if (mounted && !context.read<BookingCubit>().hasMoreBookings()) {
        return;
      }
// nextPageTrigger will have a value equivalent to 70% of the list size.
      final nextPageTrigger = 0.7 * widget.scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
      if (widget.scrollController.position.pixels > nextPageTrigger) {
        if (mounted) {
          context.read<BookingCubit>().fetchMoreBookingDetails(status: widget.selectedStatus);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //
  void fetchBookingDetails() {
    Future.delayed(Duration.zero).then((final value) {
      context.read<BookingCubit>().fetchBookingDetails(status: widget.selectedStatus);
    });
  }

  //
  Widget _getBookingShimmerLoading({required final int numberOfShimmerContainer}) =>
      SingleChildScrollView(
        padding: EdgeInsets.only(bottom: getScrollViewBottomPadding(context)),
        child: Column(
          children: List.generate(
            numberOfShimmerContainer,
            (final int index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        const ShimmerLoadingContainer(
                          child: CustomShimmerContainer(
                            height: 35,
                            width: 35,
                          ),
                        ),
                        Column(
                          children: [
                            ShimmerLoadingContainer(
                              child: CustomShimmerContainer(
                                margin: const EdgeInsets.all(5),
                                height: 8,
                                width: MediaQuery.sizeOf(context).width * 0.7,
                              ),
                            ),
                            ShimmerLoadingContainer(
                              child: CustomShimmerContainer(
                                margin: const EdgeInsets.all(5),
                                height: 8,
                                width: MediaQuery.sizeOf(context).width * 0.7,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      margin: const EdgeInsets.all(8),
                      height: 5,
                      width: MediaQuery.sizeOf(context).width * 0.65,
                    ),
                  ),
                  ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      margin: const EdgeInsets.all(8),
                      height: 5,
                      width: MediaQuery.sizeOf(context).width * 0.65,
                    ),
                  ),
                  ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      margin: const EdgeInsets.all(8),
                      height: 5,
                      width: MediaQuery.sizeOf(context).width * 0.65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  //
  Widget getBookingDetailsData({
    required final List<Booking> bookingDetailsList,
    required final bool isLoadingMoreData,
  }) {

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: EdgeInsets.only(
        top: 5,
        bottom: getScrollViewBottomPadding(context),
      ),
      child: bookingDetailsList.isEmpty
          ? Center(
              child: NoDataContainer(
                titleKey: 'noBookingFound'.translate(context: context),
              ),
            )
          : Column(
              children:
                  List.generate(bookingDetailsList.length + (isLoadingMoreData ? 1 : 0), (final int index) {
                if (index >= bookingDetailsList.length) {
                  return Center(
                    child: _getBookingShimmerLoading(numberOfShimmerContainer: 1),
                  );
                }
                return CustomInkWellContainer(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      bookingDetails,
                      arguments: {"bookingDetails": bookingDetailsList[index]},
                    );
                  },
                  //if user cancel the booking from booking details
                  //then again state will build and remove cancelled booking
                  //from other status's booking details
                  //and  "" is used to check for all status bookings
                  child: widget.selectedStatus == "" ||
                          bookingDetailsList[index].status == widget.selectedStatus
                      ? NewBookingCardContainer(
                          bookingDetails: bookingDetailsList[index],
                        )
                      : Container(),
                );
              }),
            ),
    );
  }

  //
  @override
  Widget build(final BuildContext context) =>
      BlocListener<ChangeBookingStatusCubit, ChangeBookingStatusState>(
        listener: (context, state) {
          if (state is ChangeBookingStatusFailure) {
            UiUtils.showMessage(context, state.errorMessage.toString().translate(context: context),
                MessageType.error);
          } else if (state is ChangeBookingStatusSuccess) {
            UiUtils.showMessage(context, state.message, MessageType.success);
            //
            context
                .read<BookingCubit>()
                .updateBookingDataLocally(latestBookingData: state.bookingData);
          }
        },
        child: BlocBuilder<BookingCubit, BookingState>(
          builder: (final BuildContext context, final BookingState state) {
            if (state is BookingFetchFailure) {
              return ErrorContainer(
                errorMessage: state.errorMessage.translate(context: context),
                onTapRetry: () {
                  fetchBookingDetails();
                },
              );
            }
            if (state is BookingFetchSuccess) {

              return state.bookingData.isEmpty
                  ? NoDataContainer(
                      titleKey: 'noBookingFound'.translate(context: context),
                    )
                  : CustomRefreshIndicator(
                      onRefreshCallback: () {
                        fetchBookingDetails();
                      },
                      displacment: 12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 15, right: 10),
                        child: getBookingDetailsData(
                          bookingDetailsList: state.bookingData,
                          isLoadingMoreData: state.isLoadingMoreData,
                        ),
                      ),
                    );
            }
            return _getBookingShimmerLoading(
              numberOfShimmerContainer: numberOfShimmerContainer,
            );
          },
        ),
      );
}
