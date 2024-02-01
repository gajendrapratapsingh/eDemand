import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllowLocationScreen extends StatefulWidget {
  const AllowLocationScreen({final Key? key}) : super(key: key);

  @override
  State<AllowLocationScreen> createState() => _AllowLocationScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final BuildContext context) => const AllowLocationScreen(),
      );
}

class _AllowLocationScreenState extends State<AllowLocationScreen> with WidgetsBindingObserver {
  bool isAppPaused = false;
  bool isAppResumed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _requestLocationPermission() {
    GetLocation().requestPermission(
      allowed: (final Position position) {
        context.read<HomeScreenCubit>().fetchHomeScreenData();
        Navigator.pop(context);
//        Navigator.pushReplacementNamed(context, navigationRoute);
      },
      onRejected: () async {
        //open app setting for permission
        //    await AppSettings.openAppSettings();
        //  UiUtils.showMessage(context, 'Permission Rejected', MessageType.warning);
      },
      onGranted: (final Position position) async {
        context.read<HomeScreenCubit>().fetchHomeScreenData();
        Navigator.pop(context);

        //  await Navigator.pushReplacementNamed(context, navigationRoute);
        //_isCityDeliverable(position);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      isAppPaused = true;
    }
    if (state == AppLifecycleState.resumed) {
      if (isAppPaused) {
        _requestLocationPermission();
        isAppPaused = false;
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgPicture(svgImage: "location_access.svg"),
                const SizedBox(height: 10),
                Text('permissionRequired'.translate(context: context)),
                const SizedBox(height: 10),
                CustomRoundedButton(
                  widthPercentage: 0.8,
                  backgroundColor: Theme.of(context).colorScheme.accentColor,
                  buttonTitle: "automaticLocation".translate(context: context),
                  showBorder: true,
                  onTap: () {
                    _requestLocationPermission();
                  },
                ),
                const SizedBox(height: 10),
                CustomRoundedButton(
                  widthPercentage: 0.8,
                  backgroundColor: Theme.of(context).colorScheme.accentColor,
                  buttonTitle: "manualLocation".translate(context: context),
                  showBorder: true,
                  onTap: () {
                    UiUtils.showBottomSheet(child: const CityBottomSheet(), context: context)
                        .then((final value) {
                      if (value != null) {
                        if (value['navigateToMap']) {
                          Navigator.pushNamed(
                            context,
                            googleMapRoute,
                            arguments: {
                              'useStoredCordinates': value["useStoredCordinates"],
                              'place': value['place'],
                              'googleMapButton': value["googleMapButton"]
                            },
                          ); /*
                        Navigator.pushReplacementNamed(context, googleMapRoute, arguments: {
                          'useStoredCordinates': value["useStoredCordinates"],
                          'place': value['place'],
                          'googleMapButton': value["googleMapButton"]
                        },);*/
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
