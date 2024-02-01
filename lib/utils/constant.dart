import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

const String appName = "eDemand";

// domainURL should look like:- https://your_domain.in
const String domainURL = "https://edemand.wrteam.me";

//Add your baseURL
const String baseUrl = "https://edemand.wrteam.me/api/v1/";

///place API key need for place searches
const String placeAPIKey = 'PLACE_YOUR_PLACE_MAP_API_KEY_HERE';

//package name
const String packageName = "PLACE_YOUR_PACKAGE_NAME_HERE";

String? systemCurrency;
String? systemCurrencyCountryCode;
String? decimalPointsForPrice;

//add your default country code here
String? defaultCountryCode = "IN";

//if you do not want user to select another country rather than default country,
//then make below variable true
bool allowOnlySingleCountry = false;

//constant variables
const String limitOfAPIData = "10";
const int resendOTPCountDownTime = 30; //in seconds

//OTP hint Text
const String otpHintText = "123456"; /* MUST BE 6 CHARACTER REQUIRED */

//global key
GlobalKey<CustomNavigationBarState> bottomNavigationBarGlobalKey =
    GlobalKey<CustomNavigationBarState>();
//
GlobalKey<BookingsScreenState> bookingScreenGlobalKey =
    GlobalKey<BookingsScreenState>();
//

const String imagePath = "assets/images";
const String animationPath = "assets/animation/";

//customer app
const String customerAppAndroidLink =
    "https://play.google.com/store/apps/details?id=$packageName";
const String customerAppIOSLink = "PLACE_YOUR_IOS_APP_LINK_HERE";

//provider app
const String providerAppAndroidLink =
    "PLACE_YOUR_ANDROID_PROVIDER_APP_LINK_HERE";
const String providerAppIOSLink = "PLACE_YOUR_IOS_PROVIDER_APP_LINK_HERE";

//deep link
const Map dynamicLink = {
  "deepLinkPrefix": "PLACE_YOUR_DEEPLINK_HERE",
  "domainURL": domainURL,
};

//slider on home screen
const Map homeScreen = {
  "sliderAnimationDuration": 3, // in seconds
  "changeSliderAnimationDuration": 300, //in milliseconds
};

//*******Add Your Language code and name here */
//by default language of the app
const String defaultLanguageCode = "en";
const String defaultLanguageName = "English";

//Add language code in this list
//visit this to find languageCode for your respective language
//https://developers.google.com/admin-sdk/directory/v1/languages
const List<AppLanguage> appLanguages = [
  //Please add language code here and language name
  AppLanguage(
      languageCode: "en", languageName: "English", imageURL: 'english-au.svg'),
  AppLanguage(
      languageCode: "hi", languageName: "हिन्दी", imageURL: 'Hindi.svg'),
  AppLanguage(languageCode: "ar", languageName: "عربى", imageURL: 'Arabic.svg'),
];

/* INTRO SLIDER LIST*/
List<IntroScreen> introScreenList = [
  IntroScreen(
    introScreenTitle: "onboarding_heading_one",
    introScreenSubTitle: "onboarding_body_one",
    imagePath: "$imagePath/image_a.png",
    animationDuration: 3, /* DURATION IS IN SECONDS*/
  ),
  IntroScreen(
    introScreenTitle: "onboarding_heading_two",
    introScreenSubTitle: "onboarding_body_two",
    imagePath: "$imagePath/image_b.png",
    animationDuration: 3, /* DURATION IS IN SECONDS*/
  ),
  IntroScreen(
    introScreenTitle: "onboarding_heading_three",
    introScreenSubTitle: "onboarding_body_three",
    imagePath: "$imagePath/image_c.png",
    animationDuration: 3, /* DURATION IS IN SECONDS*/
  ),
];

// to manage snackBar/toast/message
enum MessageType { success, error, warning }

Map<MessageType, Color> messageColors = {
  MessageType.success: Colors.green,
  MessageType.error: Colors.red,
  MessageType.warning: Colors.orange
};

Map<MessageType, IconData> messageIcon = {
  MessageType.success: Icons.done_rounded,
  MessageType.error: Icons.error_outline_rounded,
  MessageType.warning: Icons.warning_amber_rounded
};

Map<String, dynamic> dateAndTimeSetting = {
  "dateFormat": "dd/MM/yyyy",
  "use24HourFormat": true
};

//border radius
const double borderRadiusOf5 = 5;
const double borderRadiusOf10 = 10;
const double borderRadiusOf15 = 15;
const double borderRadiusOf20 = 20;
const double borderRadiusOf50 = 50;

double bottomNavigationBarHeight = kBottomNavigationBarHeight;

//
// Toast message display duration
const int messageDisplayDuration = 3000;

//shimmerLoadingContainer value
int numberOfShimmerContainer = 7;

//to give bottom scroll padding in screen where
//bottom navigation bar is displayed
double getScrollViewBottomPadding(final BuildContext context) =>
    kBottomNavigationBarHeight + 5;
