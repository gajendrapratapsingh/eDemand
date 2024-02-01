import 'package:flutter/material.dart';

extension AppColors on ColorScheme {

  static const MaterialColor primarySwatchLightColor = MaterialColor(
    0xff0277FA,
    <int, Color>{
      100: Color(0xffbae0ff),//20%
      200: Color(0xff8bcdff),//30%
      300: Color(0xff54b8ff),//40%
      400: Color(0xff1aa8ff),//50%
      500: Color(0xff0098ff),//60%
      600: Color(0xff0089ff),//70%
      700: Color(0xff0276fa),//80%
      800: Color(0xff1463e7),//90%
      900: Color(0xff2041c8),//100%
    },
  );

  static const MaterialColor primarySwatchDarkColor = MaterialColor(
    0xff0277FA,
    <int, Color>{
      100: Color(0xffbae0ff),//20%
      200: Color(0xff8bcdff),//30%
      300: Color(0xff54b8ff),//40%
      400: Color(0xff1aa8ff),//50%
      500: Color(0xff0098ff),//60%
      600: Color(0xff0089ff),//70%
      700: Color(0xff0276fa),//80%
      800: Color(0xff1463e7),//90%
      900: Color(0xff2041c8),//100%
    },
  );

  static Color lightPrimaryColor = const Color(0xffF2F1F6); //background color
  static Color lightSecondaryColor = const Color(0xffFFFFFF);
  static Color lightAccentColor = const Color(0xff0277FA);
  static Color lightSubHeadingColor1 = const Color(0xff343F53);

  static Color darkPrimaryColor = const Color(0xff1E1E2C);
  static Color darkSecondaryColor = const Color(0xff2A2C3E);
  static Color darkAccentColor = const Color(0xff56A4FB);
  static Color darkSubHeadingColor1 = const Color(0xDDF2F1F6);

  //splashScreen GradientColor
  static Color splashScreenGradientTopColor = const Color(0xff2050D2);
  static Color splashScreenGradientBottomColor = const Color(0xff143386);

  Color get primaryColor => brightness == Brightness.light ? lightPrimaryColor : darkPrimaryColor;

  Color get secondaryColor =>
      brightness == Brightness.light ? lightSecondaryColor : darkSecondaryColor;

  Color get accentColor => brightness == Brightness.light ? lightAccentColor : darkAccentColor;

  Color get lightGreyColor => blackColor.withOpacity(0.7);

  Color get blackColor =>
      brightness == Brightness.light ? lightSubHeadingColor1 : darkSubHeadingColor1;

  Color get shimmerBaseColor =>
      brightness == Brightness.light ? shimmerBaseColorLight : shimmerBaseColorDark;

  Color get shimmerHighlightColor =>
      brightness == Brightness.light ? shimmerHighlightColorLight : shimmerHighlightColorDark;

  Color get shimmerContentColor =>
      brightness == Brightness.light ? shimmerContentColorLight : shimmerContentColorDark;

  //dark theme colors
  static Color shimmerBaseColorDark = Colors.grey.withOpacity(0.5);
  static Color shimmerHighlightColorDark = Colors.grey.withOpacity(0.005);
  static Color shimmerContentColorDark = Colors.black.withOpacity(0.3);

//light theme colors
  static Color shimmerBaseColorLight = Colors.black.withOpacity(0.05);
  static Color shimmerHighlightColorLight = Colors.black.withOpacity(0.005);
  static Color shimmerContentColorLight = Colors.white;

// Other colors
  static Color redColor = Colors.red;
  static Color whiteColors = Colors.white;
  static Color ratingStarColor = Colors.amber;
}
