import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MaintenanceModeScreen extends StatelessWidget {

  const MaintenanceModeScreen({required this.message, final Key? key}) : super(key: key);
  final String message;

  static Route<MaintenanceModeScreen> route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final _) => MaintenanceModeScreen(message: routeSettings.arguments as String),);

  @override
  Widget build(final BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: const RiveAnimation.asset(
                    'assets/animation/maintenance_mode.riv',
                    fit: BoxFit.contain,
                    artboard: 'maintenance',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('underMaintenance'.translate(context: context),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,),
                      textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                      (message.isNotEmpty)
                          ? message
                          : 'underMaintenanceSubTitle'.translate(context: context),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.blackColor,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,),
                      textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),
        ),
      ),
    );

}
