// ignore_for_file: sized_box_for_whitespace, file_names

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';

class CustomOnBoarding extends StatefulWidget {

  const CustomOnBoarding(
      { required this.pageController, required this.heading, required this.body, required this.assetImagePath, required this.currentScreenNumber, required this.totalScreen, final Key? key,
      this.time = const Duration(seconds: 3),})
      : super(key: key);
  final String assetImagePath;
  final String body;
  final int currentScreenNumber;
  final String heading;
  final PageController pageController;
  final Duration time;
  final int totalScreen;

  @override
  State<CustomOnBoarding> createState() => _CustomOnBoardingState();
}

class _CustomOnBoardingState extends State<CustomOnBoarding> with TickerProviderStateMixin {
  late final AnimationController _progressAnimationController =
      AnimationController(vsync: this, duration: widget.time)..forward();

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _progressAnimationController.addStatusListener((final AnimationStatus status) {
      if (status == AnimationStatus.completed && widget.currentScreenNumber != widget.totalScreen) {
        widget.pageController
            .nextPage(duration: const Duration(milliseconds: 400), curve: Curves.linear);
      }
      if (status == AnimationStatus.completed && widget.currentScreenNumber == widget.totalScreen) {
        Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (final route) => false,
            arguments: {"source": "introSliderScreen"},);

      }
    });
  }

  Container _buildDownToUpGradientContainer() => Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.1, 0.54],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],),),
    );

  Container _buildOnboardingBackgroundImage() => Container(
      width:MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(widget.assetImagePath),
        ),
      ),
    );

  Container _buildBottomContainer( final context) => Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.heading.translate(context: context),
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.w500, color: Colors.white,),
                    ),),
                SizedBox(
                  height: 10.rh(context),
                ),
                Text(
                  widget.body.translate(context: context),
                  style: const TextStyle(color: Color(0xfffafbfb), fontSize: 17.4),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: CustomFlatButton(
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  width: 70.rw(context),
                  height: 32.rh(context),
                  text: '${widget.currentScreenNumber}-${widget.totalScreen}',
                ),
              ),),
          Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                  animation: _progressAnimationController,
                  builder: (  BuildContext context, Widget?  child) => LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0),
                      color: Colors.white,
                      value: _progressAnimationController.value,
                      minHeight: 5,
                    ),),)
        ],
      ),
    );

  @override
  Widget build(final BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildOnboardingBackgroundImage(),
          _buildDownToUpGradientContainer(),
          Positioned.directional(
              textDirection: Directionality.of(context),
              top: 50,
              end: 20,
              child: CustomFlatButton(
                  innerPadding: 10,
                  text: "skip_here".translate(context: context),
                  backgroundColor: Colors.grey.withOpacity(0.4),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (final route) => false,
                    arguments: {"source" : "introSliderScreen"},
                    );
                  },),),
          Positioned.directional(
              bottom: 0,
              textDirection: Directionality.of(context),
              child: _buildBottomContainer( context),),
        ],
      ),
    );
  }
}
