import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CancelAndRescheduleButton extends StatelessWidget {
  final String buttonName;
  final String bookingId;
  final VoidCallback? onButtonTap;

  const CancelAndRescheduleButton(
      {super.key, required this.buttonName, this.onButtonTap, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangeBookingStatusCubit, ChangeBookingStatusState>(
      builder: (final context, final ChangeBookingStatusState state) {
        Widget? child;
        if (state is ChangeBookingStatusInProgress) {
          if (state.pressedButtonName == buttonName && state.bookingId == bookingId) {
            child = CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondaryColor,
            );
          } else if (state.pressedButtonName == buttonName && state.bookingId == bookingId) {
            child = CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondaryColor,
            );
          }
        }
        //
        return Align(
          alignment: Alignment.bottomCenter,
          child: CustomRoundedButton(
            onTap: onButtonTap,
            backgroundColor: Theme.of(context).colorScheme.accentColor,
            buttonTitle: buttonName.translate(context: context),
            titleColor: AppColors.whiteColors,
            showBorder: false,
            widthPercentage: 0.9,
            child: child,
          ),
        );
      },
    );
  }
}
