// ignore_for_file: file_names, use_build_context_synchronously

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({final Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final _) => const SplashScreen(),
      );
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((final value) {
      context.read<CountryCodeCubit>().loadAllCountryCode(context);
      context.read<SystemSettingCubit>().getSystemSettings();

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: AppColors.splashScreenGradientTopColor,
            systemNavigationBarColor: AppColors.splashScreenGradientBottomColor,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light),
      );
    });
    Hive.box(userDetailBoxKey).toMap();
    //
    context.read<UserDetailsCubit>().loadUserDetails();
    //

    //if already we have lat-long of customer then no need to get it again
    if ((Hive.box(userDetailBoxKey).get(longitudeKey) == null &&
            Hive.box(userDetailBoxKey).get(latitudeKey) == null)||
       ( Hive.box(userDetailBoxKey).get(longitudeKey) == "" &&
        Hive.box(userDetailBoxKey).get(latitudeKey) == "")) {
      GetLocation().requestPermission(onGranted: (position) {
        //if permission is allowed recently then this method will invoke,
        // we will store latitude and longitude
        Hive.box(userDetailBoxKey).put(longitudeKey, position.longitude);
        Hive.box(userDetailBoxKey).put(latitudeKey, position.latitude);
      }, allowed: (position) {
        //if permission is allowed already then this method will invoke,
        // we will store latitude and longitude
        Hive.box(userDetailBoxKey).put(longitudeKey, position.longitude);
        Hive.box(userDetailBoxKey).put(latitudeKey, position.latitude);
      }, onRejected: () {
        //if permission is rejected then we will store empty string

        Hive.box(userDetailBoxKey).put(longitudeKey, "");
        Hive.box(userDetailBoxKey).put(latitudeKey, "");
      });
      context.read<GeolocationCubit>().getGeoLocation();
    }
  }

  Future<void> _checkAuthentication({required final bool isNeedToShowAppUpdate}) async {
    await Future.delayed(const Duration(seconds: 3), () {
      final authStatus = context.read<AuthenticationCubit>().state;

      if (authStatus is AuthenticatedState) {
        Navigator.pushReplacementNamed(context, navigationRoute);
        //
        if (isNeedToShowAppUpdate) {
          //if need to show app update screen then
          // we will push update screen, with not now button option
          Navigator.pushNamed(context, appUpdateScreen, arguments: {"isForceUpdate": false});
        }
        return;
      }
      if (authStatus is UnAuthenticatedState) {
        //
        final isFirst = Hive.box(authStatusBoxKey).get(isUserFirstTime);
        final isSkippedLoginBefore =
            Hive.box(authStatusBoxKey).get(isUserSkippedLoginBefore) ?? false;
        //
        if (isFirst == null) {
          Hive.box(authStatusBoxKey).put(isUserFirstTime, false);
          Navigator.pushReplacementNamed(context, onBoardingRoute);
        } else if (isSkippedLoginBefore) {
          Navigator.pushReplacementNamed(context, navigationRoute);
        } else {
          Navigator.pushReplacementNamed(
            context,
            loginRoute,
            arguments: {"source": "splashScreen"},
          );
        }
        if (isNeedToShowAppUpdate) {
          //if need to show app update screen then
          // we will push update screen, with not now button option
          Navigator.pushNamed(context, appUpdateScreen, arguments: {"isForceUpdate": false});
        }
      }
    });
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        body: BlocConsumer<SystemSettingCubit, SystemSettingState>(
          listener: (final BuildContext context, final SystemSettingState state) async {
            if (state is SystemSettingFetchSuccess) {
              final generalSettings = state.systemSettingDetails.generalSettings!;
              //
              // if maintenance mode is enable then we will redirect maintenance mode screen
              if (generalSettings.customerAppMaintenanceMode == '1') {
                await Navigator.pushReplacementNamed(
                  context,
                  maintenanceModeScreen,
                  arguments: generalSettings.messageForCustomerApplication,
                );
                return;
              }

              // here we will check current version and updated version from panel
              // if application current version is less than updated version then
              // we will show app update screen

              final String? latestAndroidVersion = generalSettings.customerCurrentVersionAndroidApp;
              final latestIOSVersion = generalSettings.customerCurrentVersionIosApp;

              final packageInfo = await PackageInfo.fromPlatform();

              final currentApplicationVersion = packageInfo.version;

              final currentVersion = Version.parse(currentApplicationVersion);
              final latestVersionAndroid = Version.parse(latestAndroidVersion ?? '1.0.0');
              final latestVersionIos = Version.parse(latestIOSVersion ?? '1.0.0');

              if ((Platform.isAndroid && latestVersionAndroid > currentVersion) ||
                  (Platform.isIOS && latestVersionIos > currentVersion)) {
                // If it is force update then we will show app update with only Update button
                if (generalSettings.customerCompulsaryUpdateForceUpdate == '1') {
                  await Navigator.pushReplacementNamed(
                    context,
                    appUpdateScreen,
                    arguments: {'isForceUpdate': true},
                  );
                  return;
                } else {
                  // If it is normal update then
                  // we will pass true here for isNeedToShowAppUpdate
                  _checkAuthentication(isNeedToShowAppUpdate: true);
                }
              } else {
                //if no update available then we will pass false here for isNeedToShowAppUpdate
                _checkAuthentication(isNeedToShowAppUpdate: false);
              }
            }
          },
          builder: (final BuildContext context, final SystemSettingState state) {
            if (state is SystemSettingFetchFailure) {
              return ErrorContainer(
                errorMessage: state.errorMessage.toString().translate(context: context),
                onTapRetry: () {
                  context.read<SystemSettingCubit>().getSystemSettings();
                },
              );
            }
            return Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff2050D2),
                        Color(0xff143386),
                      ],
                      stops: [0, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: Center(
                    child:
                        CustomSvgPicture(svgImage: "splash_logo.svg", height: 240, width: 220),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomSvgPicture(svgImage: "wrteam_logo.svg", width: 135, height: 25),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
