import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ReOrderButton extends StatelessWidget {
  final String bookingId;
  final String isReorderFrom;
  final Booking bookingDetails;

  const ReOrderButton(
      {super.key,
      required this.bookingId,
      required this.isReorderFrom,
      required this.bookingDetails});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (final BuildContext context, CartState state) {
        if (state is CartFetchFailure) {
          //
          UiUtils.showMessage(
              context, state.errorMessage.translate(context: context), MessageType.error);
        } else if (state is CartFetchSuccess) {
          if (state.isReorderCart &&
              state.reOrderId == bookingId &&
              bookingDetails == state.bookingDetails &&
              isReorderFrom == state.isReorderFrom) {
            //
            context
                .read<GetPromocodeCubit>()
                .getPromocodes(providerId: state.reOrderCartData?.providerId ?? "0");
            //
            Navigator.pushNamed(
              context,
              scheduleScreenRoute,
              arguments: {
                "isFrom": "reOrder",
                "providerName": state.reOrderCartData?.providerName,
                "providerId": state.reOrderCartData?.providerId,
                "companyName": state.reOrderCartData?.companyName,
                "providerAdvanceBookingDays": state.reOrderCartData?.advanceBookingDays,
                "orderID": state.reOrderId
              },
            );
          }
        }
      },
      builder: (final BuildContext context, final CartState state) {
        Widget? child;
        if (state is CartFetchInProgress) {
          if (state.reOrderId == bookingId)
            child = CircularProgressIndicator(color: AppColors.whiteColors);
        }
        //
        return Align(
          alignment: Alignment.bottomCenter,
          child: CustomRoundedButton(
            onTap: () {
              if (state is CartFetchInProgress) {
                return;
              }
              context.read<CartCubit>().getCartDetails(
                  isReorderFrom: isReorderFrom,
                  bookingDetails: bookingDetails,
                  reOrderId: bookingId,
                  isReorderCart: true);
            },
            backgroundColor: Theme.of(context).colorScheme.accentColor,
            buttonTitle: "reOrder".translate(context: context),
            showBorder: false,
            widthPercentage: 0.9,
            titleColor: AppColors.whiteColors,
            child: child,
          ),
        );
      },
    );
  }
}
