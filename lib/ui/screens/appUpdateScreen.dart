import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AppUpdateScreen extends StatelessWidget {

  const AppUpdateScreen({required this.isForceUpdate, final Key? key}) : super(key: key);
  final bool isForceUpdate;

  static Route route(final RouteSettings settings) {
    final arguments = settings.arguments as Map;
    return CupertinoPageRoute(builder: (final context) => AppUpdateScreen(
        isForceUpdate: arguments["isForceUpdate"],
      ),);
  }

  @override
  Widget build(final BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).width * 0.6,
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: const RiveAnimation.asset(
                  'assets/animation/maintenance_mode.riv',
                  fit: BoxFit.contain,
                  artboard: 'we are updating',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('updateAppTitle'.translate(context: context),
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
                    isForceUpdate
                        ? 'compulsoryUpdateSubTitle'.translate(context: context)
                        : 'normalUpdateSubTitle'.translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,),
                    textAlign: TextAlign.center,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomRoundedButton(
                  onTap: () {
                    if (Platform.isAndroid) {
                      launchUrl(Uri.parse(customerAppAndroidLink),
                          mode: LaunchMode.externalApplication,);
                    } else if (Platform.isIOS) {
                      launchUrl(Uri.parse(customerAppIOSLink), mode: LaunchMode.externalApplication);
                    }
                  },
                  widthPercentage: 1,
                  backgroundColor: Theme.of(context).colorScheme.accentColor,
                  showBorder: false,
                  buttonTitle: 'update'.translate(context: context),
                  titleColor: AppColors.whiteColors,
                ),
              ),
              if (!isForceUpdate)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomRoundedButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    widthPercentage: 1,
                    backgroundColor: Theme.of(context).colorScheme.primaryColor,
                    showBorder: true,
                    borderColor: Theme.of(context).colorScheme.blackColor,
                    buttonTitle: 'notNow'.translate(context: context),
                    titleColor: Theme.of(context).colorScheme.blackColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

}
