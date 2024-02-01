import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // ignore_for_file: file_names

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({final Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(builder: (final _) => const OnBoardingScreen(),);
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _onBoardingPagesController = PageController();

  @override
  void initState() {
    super.initState();

    /// loading country codes before we load login screen
    context.read<CountryCodeCubit>().loadAllCountryCode(context);
  }

  @override
  void dispose() {

    _onBoardingPagesController.dispose(); super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,),
      child: Scaffold(
        body: PageView(
          controller: _onBoardingPagesController,
          children: List.generate(
              introScreenList.length,
              (final int index) => CustomOnBoarding(
                    heading: introScreenList[index].introScreenTitle,
                    body: introScreenList[index].introScreenSubTitle,
                    assetImagePath: introScreenList[index].imagePath,
                    pageController: _onBoardingPagesController,
                    totalScreen: introScreenList.length,
                    currentScreenNumber: index + 1,
                    time: Duration(seconds: introScreenList[index].animationDuration),
                  ),),
        ),
      ),
    );
}
