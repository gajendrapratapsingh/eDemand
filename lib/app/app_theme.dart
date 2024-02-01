import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

enum AppTheme { dark, light }

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.light: ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: AppColors.lightPrimaryColor,
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimaryColor,
    secondaryHeaderColor: AppColors.lightSubHeadingColor1,
    fontFamily: "PlusJakartaSans",
    primarySwatch: AppColors.primarySwatchLightColor,
  ),
  //
  AppTheme.dark: ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryColor,
    secondaryHeaderColor: AppColors.darkSubHeadingColor1,
    scaffoldBackgroundColor: AppColors.darkPrimaryColor,
    primarySwatch: AppColors.primarySwatchDarkColor,
    fontFamily: "PlusJakartaSans",
  )
};
