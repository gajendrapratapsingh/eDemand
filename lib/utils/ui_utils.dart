// ignore_for_file: prefer_final_locals

import 'dart:ui';

import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/widgets/loginDialogScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

class UiUtils {

  static Locale getLocaleFromLanguageCode(final String languageCode) {
    final result = languageCode.split("-");
    return result.length == 1 ? Locale(result.first) : Locale(result.first, result.last);
  }

  static Future<void> showMessage(
      final BuildContext context, final String text, final MessageType type) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (final context) => Positioned(
        left: 5,
        right: 5,
        bottom: 15,
        child: MessageContainer(
          context: context,
          text: text,
          type: type,
        ),
      ),
    );
    overlayState.insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: messageDisplayDuration));

    overlayEntry.remove();
  }

// Only numbers can be entered
  static List<TextInputFormatter> allowOnlyDigits() =>
      <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];

  //
  static Future<dynamic> showBottomSheet({
    required final BuildContext context,
    required final Widget child,
    final Color? backgroundColor,
    final bool? enableDrag,
    final bool? isScrollControlled,
    final bool? useSafeArea,
  }) async {
    final result = await showModalBottomSheet(
      enableDrag: enableDrag ?? false,
      isScrollControlled: isScrollControlled ?? true,
      useSafeArea: useSafeArea ?? false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadiusOf20),
          topRight: Radius.circular(borderRadiusOf20),
        ),
      ),
      context: context,
      builder: (final _) {
        //using backdropFilter to blur the background screen
        //while bottomSheet is open
        return BackdropFilter(filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), child: child);
      },
    );

    return result;
  }

  static Future<dynamic> showCustomDialog({
    required final BuildContext context,
    required final Widget child,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (final _) {
        //using backdropFilter to blur the background screen
        //while bottomSheet is open
        return BackdropFilter(filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), child: child);
      },
    );
    return result;
  }

  static String getImagePath(final String imageName) => 'assets/images/$imageName';

  static AppBar getSimpleAppBar({
    required final BuildContext context,
    required final String title,
    final Color? backgroundColor,
    final bool? centerTitle,
    final bool? isLeadingIconEnable,
    final double? elevation,
    final List<Widget>? actions,
  }) =>
      AppBar(
        systemOverlayStyle: UiUtils.getSystemUiOverlayStyle(context: context),
        leading: isLeadingIconEnable ?? true
            ? CustomInkWellContainer(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
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
                    ),
                  ),
                ),
              )
            : Container(),
        title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.blackColor)),
        centerTitle: centerTitle ?? false,
        elevation: elevation ?? 0.0,
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondaryColor,
        actions: actions ?? [],
      );

  static SystemUiOverlayStyle getSystemUiOverlayStyle({required final BuildContext context}) =>
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.secondaryColor,
        systemNavigationBarColor: Theme.of(context).colorScheme.secondaryColor,
        systemNavigationBarIconBrightness:
            context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarIconBrightness: context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
            ? Brightness.light
            : Brightness.dark,
      );


  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Future<bool> clearUserData() async {
    try {
      final String latitude = Hive.box(userDetailBoxKey).get(latitudeKey).toString();
      final String longitude = Hive.box(userDetailBoxKey).get(longitudeKey).toString();
      final String currentLocationName = Hive.box(userDetailBoxKey).get(locationName).toString();

      //
      await FirebaseAuth.instance.signOut();
      await Hive.box(authStatusBoxKey).put(isAuthenticated, false);

      await Hive.box(userDetailBoxKey).clear();
      //
      //we will store latitude,longitude and location name to fetch data based on latitude and longitude
      await Hive.box(userDetailBoxKey).putAll(
        {longitudeKey: longitude, latitudeKey: latitude, locationName: currentLocationName},
      );
      //
      NotificationService.disposeListeners();
      //
      return true;
    } catch (e) {
      return false;
    }
  }


  static Color getStatusColor(
      {required final BuildContext context, required final String statusVal}) {
    Color stColor;
    switch (statusVal) {
      case "awaiting":
        stColor = Colors.grey.shade500;
        break;
      case "confirmed":
        stColor = Colors.green.shade500;
        break;
      case "started":
        stColor = const Color(0xff0096FF);
        break;
      case "rescheduled": //Rescheduled
        stColor = Colors.grey.shade500;
        break;
      case "cancelled": //Cancelled
        stColor = Colors.red;
        break;
      case "completed":
        stColor = Colors.green;
        break;
      default:
        stColor = Colors.green;
        break;
    }
    return stColor;
  }

  static Map<String, dynamic> getStatusColorAndImage(
      {required final BuildContext context, required final String statusVal}) {
    Color stColor;
    String imageName;
    switch (statusVal) {
      case "awaiting":
        stColor = const Color(0xff9E9E9E);
        imageName = "Awaiting";
        break;
      case "confirmed":
        stColor = const Color(0xffD6A90A);
        imageName = "Confirmed";
        break;
      case "started":
        stColor = const Color(0xff23AEFE);
        imageName = "Started";
        break;
      case "rescheduled": //Rescheduled
        stColor = const Color(0xff2560FC);
        imageName = "Rescheduled";
        break;
      case "cancelled": //Cancelled
        stColor = const Color(0xffFF0D09);
        imageName = "Cancelled";
        break;
      case "completed":
        stColor = const Color(0xff0AC836);
        imageName = "Completed";
        break;
      default:
        stColor = const Color(0xff0AC836);
        imageName = "Completed";
        break;
    }
    return {"color": stColor, "imageName": imageName};
  }

  static Future<void> getVibrationEffect() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 100);
    }
  }

  static Future<void> showLoginDialog({required final BuildContext context}) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (final context, final animation, final secondaryAnimation) => Container(),
      transitionBuilder: (final context, final animation, final secondaryAnimation, Widget child) =>
          Transform.scale(
        scale: Curves.easeInOut.transform(animation.value),
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadiusOf10)),
          child: const LogInDialogScreen(),
        ),
      ),
    );
  }
}
