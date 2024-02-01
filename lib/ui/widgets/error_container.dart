import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {

  const ErrorContainer(
      { required this.errorMessage, final Key? key,
      this.errorMessageColor,
      this.buttonName,
      this.errorMessageFontSize,
      this.onTapRetry,
      this.showErrorImage,
      this.retryButtonBackgroundColor,
      this.retryButtonTextColor,
      this.showRetryButton,})
      : super(key: key);
  final String errorMessage;
  final String? buttonName;
  final bool? showErrorImage;
  final Color? errorMessageColor;
  final double? errorMessageFontSize;
  final Function? onTapRetry;
  final bool? showRetryButton;
  final Color? retryButtonBackgroundColor;
  final Color? retryButtonTextColor;

  @override
  Widget build(final BuildContext context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage == "noInternetFound".translate(context: context)) SizedBox(
                  height: MediaQuery.sizeOf(context).height * (0.35),
                  child: SvgPicture.asset(UiUtils.getImagePath("noInternet.svg")),
                ) else SizedBox(
                  height: MediaQuery.sizeOf(context).height * (0.35),
                  child: SvgPicture.asset(
                    UiUtils.getImagePath("somethingWentWrong.svg"),
                  ),),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * (0.025),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.blackColor,
                  fontSize: errorMessageFontSize ?? 16,),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          if (showRetryButton ?? true) CustomRoundedButton(
                  height: 40,
                  widthPercentage: 0.3,
                  backgroundColor:
                      retryButtonBackgroundColor ?? Theme.of(context).colorScheme.accentColor,
                  onTap: () {
                    onTapRetry?.call();
                  },
                  titleColor: retryButtonTextColor ?? AppColors.whiteColors,
                  buttonTitle: (buttonName ?? 'retry').translate(context: context),
                  showBorder: false,) else const SizedBox()
        ],
      ),
    );
}
