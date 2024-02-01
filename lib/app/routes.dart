import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String navigationRoute = "/navigationBar";
const String allowLocationScreenRoute = "/allowLocationScreenRoute";
const String splashRoute = "/";
const String onBoardingRoute = "/onboarding";
const String loginRoute = "/login";
const String sectionDetailsRoute = "/sectionDetails";
const String countryCodePickerRoute = "/countryCodePicker";
const String otpVerificationRoute = "/login/OtpVerification";
const String subCategoryRoute = "/subCategoryScreen";
const String appSettingsRoute = "/appSettings";
const String notificationRoute = "/notifications";
const String faqsRoute = "/faqs";
const String profileRoute = "/profile";
const String editProfileRoute = "/$profileRoute/editProfile";
const String googleMapRoute = "/googleMapScreen";
const String scheduleScreenRoute = "/scheduleScreen";
const String providerRoute = "/providerRoute";
const String notAvailable = "/notAvailable";
const String bookmarkRoute = "/bookmarkRoute";
const String orderSummaryDetailsRoute = "/orderSummaryDetailsRoute";
const String orderConfirmation = "/orderConfirmation";
const String promocodeScreen = "/promocodeScreen";
const String searchScreen = "/searchScreen";
const String bookingDetails = "/bookingDetails";
const String paymentDetailsScreen = "/paymentDetailsScreen";
const String manageAddressScreen = "/manageAddressScreen";
const String maintenanceModeScreen = "/maintenanceModeScreen";
const String appUpdateScreen = "/appUpdateScreen";
const String imagePreview = "/imagePreview";
const String paypalPaymentScreen = "/paypalPaymentScreen";

class Routes {
  //
  static String currentRoute = splashRoute;
  static String previousRoute = "";
  static String secondPreviousRoute = "";

  static Route<dynamic> onGeneratedRoute(final RouteSettings routeSettings) {
    //
    secondPreviousRoute = previousRoute;
    previousRoute = currentRoute;
    currentRoute = routeSettings.name ?? "";

    switch (routeSettings.name) {
      case navigationRoute:
        return CustomNavigationBar.route(routeSettings);

      case splashRoute:
        return SplashScreen.route(routeSettings);

      case onBoardingRoute:
        return OnBoardingScreen.route(routeSettings);

      case loginRoute:
        return LogInScreen.route(routeSettings);

      case countryCodePickerRoute:
        return CountryCodePickerScreen.route(routeSettings);

      case otpVerificationRoute:
        return OtpVerificationScreen.route(routeSettings);

      case subCategoryRoute:
        return SubCategoryScreen.route(routeSettings);

      case notificationRoute:
        return NotificationScreen.route(routeSettings);

      case faqsRoute:
        return FaqsScreen.route(routeSettings);

      case allowLocationScreenRoute:
        return AllowLocationScreen.route(routeSettings);

      case editProfileRoute:
        return EditProfileScreen.route(routeSettings);

      case googleMapRoute:
        return GoogleMapScreen.route(routeSettings);

      case scheduleScreenRoute:
        return ScheduleScreen.route(routeSettings);

      case orderSummaryDetailsRoute:
        return OrderSummeryScreen.route(routeSettings);

      case providerRoute:
        return ProviderDetailsScreen.route(routeSettings);

      case bookmarkRoute:
        return BookmarkScreen.route(routeSettings);

      case orderConfirmation:
        return OrderConfirm.route(routeSettings);

      case promocodeScreen:
        return PromoCodeScreen.route(routeSettings);

      case notAvailable:
        return CupertinoPageRoute(builder: (final _) => const NotAvailable());

      case manageAddressScreen:
        return ManageAddress.route(routeSettings);

      case appSettingsRoute:
        return AppSettingsScreen.route(routeSettings);

      case paypalPaymentScreen:
        return PayPalPaymentScreen.route(routeSettings);

      case searchScreen:
        return SearchScreen.route(routeSettings);

      case bookingDetails:
        return BookingDetails.route(routeSettings);

      case paymentDetailsScreen:
        return PaymentsScreen.route(routeSettings);

      case maintenanceModeScreen:
        return MaintenanceModeScreen.route(routeSettings);

      case appUpdateScreen:
        return AppUpdateScreen.route(routeSettings);

      case imagePreview:
        return ImagePreview.route(routeSettings);

      default:
        return CupertinoPageRoute(
            builder: (final _) => const Scaffold(
                  body: Center(child: Text("somwthing went wrong")),
                ),);
    }
  }
}
