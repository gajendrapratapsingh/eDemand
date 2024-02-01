import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/screens/bookings_details/widgets/newBookingCardContainer.dart';

import '../widgets/sliderImageContainer.dart';
import "../../utils/appQuickActions.dart";
import 'package:flutter/material.dart'; // ignore_for_file: use_build_context_synchronously

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.scrollController, final Key? key}) : super(key: key);
  final ScrollController scrollController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FocusNode searchBarFocusNode = FocusNode();
  String address = "Select your address";

  //
  //this is used to show shadow under searchbar while scrolling
  ValueNotifier<bool> showShadowBelowSearchBar = ValueNotifier(false);

  //
  @override
  void dispose() {
    showShadowBelowSearchBar.dispose();
    searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    AppQuickActions.initAppQuickActions();
    AppQuickActions.createAppQuickActions();
    //
    checkLocationPermission();
    //
    if (Hive.box(authStatusBoxKey).get(isAuthenticated) != null ||
        Hive.box(authStatusBoxKey).get(isAuthenticated) != false) {
      LocalAwsomeNotification().init(context);
      NotificationService.init(context);
    }
    Future.delayed(Duration.zero, fetchHomeScreenData);
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels > 7 && !showShadowBelowSearchBar.value) {
      showShadowBelowSearchBar.value = true;
    } else if (widget.scrollController.position.pixels < 7 && showShadowBelowSearchBar.value) {
      showShadowBelowSearchBar.value = false;
    }
  }

  Future<void> fetchHomeScreenData() async {
    //
    final Map<String, dynamic> currencyData =
        context.read<SystemSettingCubit>().getSystemCurrencyDetails();

    systemCurrency = currencyData['currencySymbol'];
    systemCurrencyCountryCode = currencyData['currencyCountryCode'];
    decimalPointsForPrice = currencyData['decimalPoints'];
    //
    final List<Future> futureAPIs = <Future>[
      context.read<HomeScreenCubit>().fetchHomeScreenData(),
      if (Hive.box(userDetailBoxKey).get(tokenIdKey) != null) ...[
        context.read<CartCubit>().getCartDetails(isReorderCart: false),
        context.read<BookmarkCubit>().fetchBookmark(type: 'list')
      ]
    ];
    await Future.wait(futureAPIs);
  }

  Future<void> checkLocationPermission() async {
    //
    final LocationPermission permission = await Geolocator.checkPermission();
    //
    if ((permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) &&
        ((Hive.box(userDetailBoxKey).get(latitudeKey) == "0.0" ||
                Hive.box(userDetailBoxKey).get(latitudeKey) == "") &&
            (Hive.box(userDetailBoxKey).get(longitudeKey) == "0.0" ||
                Hive.box(userDetailBoxKey).get(longitudeKey) == ""))) {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, allowLocationScreenRoute);
        /*Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (_) => const AllowLocationScreen()));*/
      });
    }
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final Box userDetailBox = Hive.box(userDetailBoxKey);
      Position position;

      if (userDetailBox.get(latitudeKey) != null &&
          userDetailBox.get(longitudeKey) != null &&
          userDetailBox.get(latitudeKey) != "" &&
          userDetailBox.get(longitudeKey) != "") {
        final latitude = userDetailBox.get(latitudeKey) ?? "0.0";
        final longitude = userDetailBox.get(longitudeKey) ?? "0.0";

        await GeocodingPlatform.instance.placemarkFromCoordinates(
          double.parse(latitude.toString()),
          double.parse(longitude.toString()),
        );
      } else {
        position = await Geolocator.getCurrentPosition();
        await GeocodingPlatform.instance
            .placemarkFromCoordinates(position.latitude, position.longitude);
      }

      address = userDetailBox.get(locationName) ?? "";

      setState(() {});
    }
  }

  @override
  Widget build(final BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: SafeArea(
          child: Scaffold(
            appBar: _getAppBar(),
            body: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Expanded(
                      child: BlocBuilder<CartCubit, CartState>(
                        // we have added Cart cubit
                        // because we want to calculate bottom padding of scroll
                        //
                        builder: (final BuildContext context, final CartState state) =>
                            BlocBuilder<HomeScreenCubit, HomeScreenState>(
                          builder: (context, HomeScreenState homeScreenState) {
                            if (homeScreenState is HomeScreenDataFetchSuccess) {
                              /* If data available in cart then it will return providerId,
                            and if it's returning 0 means cart is empty
                            so we do not need to add extra bottom height for padding
                            */
                              final cartButtonHeight =
                                  context.read<CartCubit>().getProviderIDFromCartData() == '0'
                                      ? 0
                                      : bottomNavigationBarHeight + 10;
                              if (homeScreenState.homeScreenData.category!.isEmpty &&
                                  homeScreenState.homeScreenData.sections!.isEmpty &&
                                  homeScreenState.homeScreenData.sliders!.isEmpty) {
                                return Center(
                                  child: NoDataContainer(
                                    titleKey: 'weAreNotAvailableHere'.translate(context: context),
                                  ),
                                );
                              }
                              return CustomRefreshIndicator(
                                onRefreshCallback: fetchHomeScreenData,
                                displacment: 12,
                                child: SingleChildScrollView(
                                  controller: widget.scrollController,
                                  padding: EdgeInsets.only(
                                    bottom: getScrollViewBottomPadding(context) +
                                        cartButtonHeight,
                                  ),
                                  child: Column(
                                    children: [
                                      homeScreenState.homeScreenData.sliders!.isEmpty
                                          ? Container()
                                          : SliderImageContainer(
                                              sliderImages: homeScreenState.homeScreenData.sliders!,
                                            ),
                                      _getCategoryListContainer(
                                        categoryList: homeScreenState.homeScreenData.category!,
                                      ),
                                      _getSections(
                                        sectionsList: homeScreenState.homeScreenData.sections!,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (homeScreenState is HomeScreenDataFetchFailure) {
                              return ErrorContainer(
                                errorMessage:
                                    homeScreenState.errorMessage.translate(context: context),
                                onTapRetry: () {
                                  fetchHomeScreenData();
                                },
                              );
                            }
                            return _homeScreenShimmerLoading();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                ValueListenableBuilder(
                  builder: (final BuildContext context, final Object? value, final Widget? child) =>
                      Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryColor,
                      boxShadow: showShadowBelowSearchBar.value
                          ? [
                              BoxShadow(
                                offset: const Offset(0, 0.75),
                                spreadRadius: 1,
                                blurRadius: 5,
                                color: Theme.of(context).colorScheme.blackColor.withOpacity(0.2),
                              )
                            ]
                          : [],
                    ),
                    child: _getSearchBarContainer(),
                  ),
                  valueListenable: showShadowBelowSearchBar,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomNavigationBarHeight),
                  child: const Align(alignment: Alignment.bottomCenter, child: CartSubDetails()),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _getSearchBarContainer() => CustomInkWellContainer(
        onTap: () async {
          await Navigator.pushNamed(context, searchScreen);
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryColor,
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  'searchProvider'.translate(context: context),
                  style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor),
                ),
              ),
              Expanded(
                child: CustomSvgPicture(
                  svgImage: 'search.svg',
                  color: Theme.of(context).colorScheme.accentColor,
                ),
              )
            ],
          ),
        ),
      );

  Widget _getCategoryTextContainer() => Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'category'.translate(context: context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            // CustomSvgPicture(svgImage: 'arrow_forward.svg')
          ],
        ),
      );

  Widget _getCategoryListContainer({required final List<CategoryModel> categoryList}) =>
      categoryList.isEmpty
          ? Container()
          : Container(
              color: Theme.of(context).colorScheme.secondaryColor,
              margin: const EdgeInsets.only(top: 5),
              child: Column(
                children: [
                  _getCategoryTextContainer(),
                  _getCategoryItemsContainer(categoryList),
                ],
              ),
            );

  Widget _getTitleShimmerEffect({
    required final double height,
    required final double width,
    required final double borderRadius,
  }) =>
      ShimmerLoadingContainer(
        child: CustomShimmerContainer(
          width: width,
          height: height,
          borderRadius: borderRadius,
        ),
      );

  Widget _getCategoryShimmerEffect() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
            child: _getTitleShimmerEffect(
              width: MediaQuery.sizeOf(context).width * (0.7),
              height: MediaQuery.sizeOf(context).height * (0.02),
              borderRadius: borderRadiusOf10,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  numberOfShimmerContainer,
                  (final int index) => Column(
                    children: [
                      const ShimmerLoadingContainer(
                        child: CustomShimmerContainer(
                          width: 75,
                          height: 75,
                          borderRadius: borderRadiusOf50,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ShimmerLoadingContainer(
                        child: _getTitleShimmerEffect(width: 75, height: 10, borderRadius: borderRadiusOf10),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _getSingleSectionShimmerEffect() => Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoadingContainer(
              child: _getTitleShimmerEffect(
                width: MediaQuery.sizeOf(context).width * (0.7),
                height: MediaQuery.sizeOf(context).height * (0.02),
                borderRadius: borderRadiusOf10,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  4,
                  (final int index) => const Padding(
                    padding: EdgeInsetsDirectional.only(top: 10, end: 5, start: 5),
                    child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                        width: 120,
                        height: 140,
                        borderRadius: borderRadiusOf15,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  AppBar _getAppBar() => AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
        leadingWidth: 0,
        leading: Container(),
        title: CustomInkWellContainer(
          onTap: () {
            UiUtils.showBottomSheet(
              enableDrag: true,
              child: const CityBottomSheet(),
              context: context,
            ).then((final value) {
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
                  );
                }
              }
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your location
              Text(
                'your_location'.translate(context: context),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.lightGreyColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                ),
                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  CustomSvgPicture(
                    svgImage: "current_location.svg",
                    height: 20,
                    width: 20,
                    color: Theme.of(context).colorScheme.accentColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box(userDetailBoxKey).listenable(),
                        builder: (BuildContext context, Box box, _) => Text(
                          box.get(locationName) ?? "selectYourLocation".translate(context: context),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          CustomInkWellContainer(
            onTap: () {
              final authStatus = context.read<AuthenticationCubit>().state;
              if (authStatus is UnAuthenticatedState) {
                UiUtils.showLoginDialog(context: context);
                /*UiUtils.showMessage(
                  context, "pleaseLogin".translate(context: context), MessageType.warning);*/
                return;
              }
              Navigator.pushNamed(context, notificationRoute);
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
              child: SvgPicture.asset(
                UiUtils.getImagePath("notification.svg"),
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.accentColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _getSections({required final List<Sections> sectionsList}) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sectionsList.length,
        itemBuilder: (final BuildContext context, int index) {
          return sectionsList[index].partners.isEmpty &&
                  sectionsList[index].subCategories.isEmpty &&
                  sectionsList[index].onGoingBookings.isEmpty &&
                  sectionsList[index].previousBookings.isEmpty
              ? Container()
              : _getSingleSectionContainer(sectionsList[index]);
        },
      );

  Widget _getSingleSectionContainer(final Sections sectionData) => SingleChildScrollView(
        child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            final token = Hive.box(userDetailBoxKey).get(tokenIdKey);
            if ((sectionData.sectionType == "previous_order" && token == null) ||
                (sectionData.sectionType == "ongoing_order" && token == null)) return Container();
            //
            return Container(
              margin: const EdgeInsets.only(top: 10),
              color: Theme.of(context).colorScheme.secondaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getSingleSectionTitle(sectionData),
                  _getSingleSectionData(sectionData),
                ],
              ),
            );
          },
        ),
      );

  Widget _getSingleSectionTitle(final Sections sectionData) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 10),
        child: Text(
          sectionData.title!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.blackColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.left,
        ),
      );

  SizedBox _getSingleSectionData(final Sections sectionData) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(end: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            sectionData.subCategories.isNotEmpty
                ? sectionData.subCategories.length
                : sectionData.partners.isNotEmpty
                    ? sectionData.partners.length
                    : sectionData.onGoingBookings.isNotEmpty
                        ? sectionData.onGoingBookings.length
                        : sectionData.previousBookings.length,
            (index) {
              if (sectionData.subCategories.isNotEmpty) {
                return SectionCardForCategoryAndProviderContainer(
                  title: sectionData.subCategories[index].name!,
                  image: sectionData.subCategories[index].image!,
                  discount: "0",
                  cardHeight: 200,
                  imageHeight: 140,
                  imageWidth: 120,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      subCategoryRoute,
                      arguments: {
                        "categoryId": sectionData.subCategories[index].id,
                        "appBarTitle": sectionData.subCategories[index].name,
                        "type": CategoryType.category,
                      },
                    );
                  },
                );
              } else if (sectionData.partners.isNotEmpty) {
                return SectionCardForCategoryAndProviderContainer(
                  title: sectionData.partners[index].companyName!,
                  image: sectionData.partners[index].image!,
                  discount: sectionData.partners[index].discount!,
                  cardHeight: 200,
                  imageHeight: 140,
                  imageWidth: 120,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      providerRoute,
                      arguments: {"providerId": sectionData.partners[index].id},
                    ).then(
                      (final Object? value) {
                        //we are changing the route name
                        //to use cartSubDetails widget to navigate to provider details screen
                        Routes.previousRoute = Routes.currentRoute;
                        Routes.currentRoute = navigationRoute;
                      },
                    );
                  },
                );
              } else if (sectionData.onGoingBookings.isNotEmpty) {
                //
                final Booking bookingData = sectionData.onGoingBookings[index];
                //

                return _getBookingDetailsCard(bookingDetailsData: bookingData);
              } else if (sectionData.previousBookings.isNotEmpty) {
                //
                final Booking bookingData = sectionData.previousBookings[index];
                //
                return _getBookingDetailsCard(bookingDetailsData: bookingData);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _getBookingDetailsCard({required Booking bookingDetailsData}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryColor,
        borderRadius: BorderRadius.circular(borderRadiusOf15),
      ),
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: NewBookingCardContainer(
        bookingDetails: bookingDetailsData,
      ),
    );
  }

  Widget _getCategoryItemsContainer(final List<CategoryModel> categoryList) => SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (context, final int index) => Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
            child: ImageWithText(
              imageURL: categoryList[index].categoryImage!,
              title: categoryList[index].name!,
              imageContainerHeight: 75,
              imageContainerWidth: 75,
              imageRadius: 0,
              textContainerHeight: 35,
              textContainerWidth: 75,
              maxLines: 2,
              darkModeBackgroundColor: categoryList[index].backgroundDarkColor,
              lightModeBackgroundColor: categoryList[index].backgroundLightColor,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  subCategoryRoute,
                  arguments: {
                    'categoryId': categoryList[index].id,
                    'appBarTitle': categoryList[index].name,
                    'type': CategoryType.category
                  },
                );
              },
            ),
          ),
        ),
      );

  Widget _homeScreenShimmerLoading() => SingleChildScrollView(
        padding: EdgeInsets.only(bottom: getScrollViewBottomPadding(context)),
        child: Column(
          children: [
            _getSliderImageShimmerEffect(),
            _getCategoryShimmerEffect(),
            Column(
              children: List.generate(
                numberOfShimmerContainer,
                (final int index) => _getSingleSectionShimmerEffect(),
              ),
            )
          ],
        ),
      );

  Widget _getSliderImageShimmerEffect() => Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, end: 15, top: 15),
        child: ShimmerLoadingContainer(
          child: CustomShimmerContainer(
            width: MediaQuery.sizeOf(context).width,
            height: 170,
            borderRadius: borderRadiusOf10,
          ),
        ),
      );
}
