import 'package:e_demand/ui/screens/provider_details/promocodeContainer.dart';
import 'package:e_demand/ui/screens/provider_details/widgets/aboutProvider/aboutProviderContainer.dart';
import 'package:e_demand/ui/screens/provider_details/widgets/services/providerServicesContainer.dart';
import 'package:e_demand/ui/widgets/review/reviewContainer.dart';
import 'package:intl/intl.dart';
import 'package:e_demand/app/generalImports.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderDetailsScreen extends StatefulWidget {
  const ProviderDetailsScreen({required this.providerID, final Key? key}) : super(key: key);
  final String providerID;

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();

  static Route route(final RouteSettings routeSettings) {
    final Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final context) => ProviderDetailsScreen(
        providerID: arguments["providerId"],
      ),
    );
  }
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //
  late TabController _tabController = TabController(length: 4, vsync: this);

  List<String> tabLabels = ['services', 'reviews', 'promocodes', 'about'];

  //
  ScrollController _serviceListScrollController = ScrollController();

  //
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((final value) {
      fetchProviderDetailsAndServices();
      context.read<GetPromocodeCubit>().getPromocodes(providerId: widget.providerID);
    });

    _tabController.addListener(tabBarListener);

    _serviceListScrollController.addListener(serviceListScrollController);
  }

  void serviceListScrollController() {
    _serviceListScrollController.addListener(() {
      if (mounted && !context.read<ProviderDetailsAndServiceCubit>().hasMoreServices()) {
        return;
      }
// nextPageTrigger will have a value equivalent to 70% of the list size.
      final nextPageTrigger = 0.7 * _serviceListScrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
      if (_serviceListScrollController.position.pixels > nextPageTrigger) {
        if (mounted) {
          context
              .read<ProviderDetailsAndServiceCubit>()
              .fetchMoreServices(providerId: widget.providerID);
        }
      }
    });
  }

  void tabBarListener() {
    Future.delayed(Duration.zero).then((value) {
      if (_tabController.index == 2) {
        if (context.read<GetPromocodeCubit>().state is FetchPromocodeFailure &&
            context.read<AuthenticationCubit>().state is! UnAuthenticatedState) {
          context.read<GetPromocodeCubit>().getPromocodes(providerId: widget.providerID);
        }
      }
    });
  }

  void fetchProviderDetailsAndServices() {
    context
        .read<ProviderDetailsAndServiceCubit>()
        .fetchProviderDetailsAndServices(providerId: widget.providerID);
    context.read<ReviewCubit>().fetchReview(providerId: widget.providerID);
  }

  Widget providerDetailsScreenShimmerLoading() => SingleChildScrollView(
        child: Column(
          children: [
            ShimmerLoadingContainer(
              child: CustomShimmerContainer(
                height: MediaQuery.sizeOf(context).height * 0.4,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            ShimmerLoadingContainer(
              child: CustomShimmerContainer(
                borderRadius: 0,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                height: 50.rh(context),
              ),
            ),
            Column(
              children: List.generate(
                numberOfShimmerContainer,
                (final int index) => const ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: 150,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  ),
                ),
              ),
            )
          ],
        ),
      );

  @override
  void dispose() {
    _serviceListScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<CartCubit, CartState>(
        listener: (final BuildContext context, final CartState state) {},
        builder: (final BuildContext context, final CartState state) =>
            BlocBuilder<ProviderDetailsAndServiceCubit, ProviderDetailsAndServiceState>(
          builder: (final context, final state) {
            if (state is ProviderDetailsAndServiceFetchFailure) {
              return Center(
                child: ErrorContainer(
                  onTapRetry: () {
                    fetchProviderDetailsAndServices();
                  },
                  errorMessage: state.errorMessage.translate(context: context),
                ),
              );
            } else if (state is ProviderDetailsAndServiceFetchSuccess) {
              return Stack(
                children: [
                  NestedScrollView(
                    controller: _serviceListScrollController,
                    headerSliverBuilder:
                        (final BuildContext context, final bool innerBoxIsScrolled) => <Widget>[
                      SliverAppBar(
                        leading: CustomInkWellContainer(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(
                              end: 10,
                              top: 10,
                              bottom: 10,
                              start: 10,
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(borderRadiusOf5),
                            ),
                            child: SvgPicture.asset(
                              context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                                  ? Directionality.of(context)
                                          .toString()
                                          .contains(TextDirection.RTL.value.toLowerCase())
                                      ? UiUtils.getImagePath("back_arrow_dark_ltr.svg")
                                      : UiUtils.getImagePath("back_arrow_dark.svg")
                                  : Directionality.of(context)
                                          .toString()
                                          .contains(TextDirection.RTL.value.toLowerCase())
                                      ? UiUtils.getImagePath("back_arrow_light_ltr.svg")
                                      : UiUtils.getImagePath("back_arrow_light.svg"),
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.accentColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        systemOverlayStyle:
                            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                        pinned: true,
                        elevation: 0,
                        expandedHeight: MediaQuery.sizeOf(context).height * 0.37,
                        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                        actions: [
                          CustomInkWellContainer(
                            child: Container(
                              margin: const EdgeInsetsDirectional.only(
                                top: 10,
                                bottom: 10,
                              ),
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.secondaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(borderRadiusOf5),
                              ),
                              child: CustomSvgPicture(
                                svgImage: 'share_sp.svg',
                                color: Theme.of(context).colorScheme.accentColor,
                              ),
                            ),
                            onTap: () async {
                              await DynamicLinkService.createDynamicLink(
                                shareUrl:
                                    '${DynamicLinkService.domainURL}/?providerId=${state.providerDetails.providerId}',
                                title: state.providerDetails.companyName,
                                imageUrl: state.providerDetails.image,
                                description: '<h1>${state.providerDetails.companyName}</h1>',
                              ).then(
                                (final String value) async => Share.share(
                                  '${state.providerDetails.companyName}\n\n$value',
                                  subject: 'Share app',
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            margin: const EdgeInsetsDirectional.only(
                              end: 10,
                              top: 10,
                              bottom: 10,
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(borderRadiusOf5),
                            ),
                            child: BookMarkIcon(
                              providerData: state.providerDetails,
                            ),
                          )
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          stretchModes: const [StretchMode.zoomBackground],
                          background: Stack(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height * 0.27,
                                child: CustomCachedNetworkImage(
                                  height: 100,
                                  width: 100,
                                  networkImageUrl: state.providerDetails.bannerImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              PositionedDirectional(
                                top: MediaQuery.sizeOf(context).height * 0.27 - 7,
                                child: Container(
                                  height: 10,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(borderRadiusOf15),
                                      topLeft: Radius.circular(borderRadiusOf15),
                                    ),
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                top: MediaQuery.sizeOf(context).height * 0.27 - 45,
                                start: (MediaQuery.sizeOf(context).width * 0.5) - 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(borderRadiusOf50),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf20)),
                                    ),
                                    child: CustomCachedNetworkImage(
                                      height: 80,
                                      width: 80,
                                      networkImageUrl: state.providerDetails.image!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                top: MediaQuery.sizeOf(context).height * 0.27 + 50,
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CustomInkWellContainer(
                                        onTap: () {
                                          _tabController.animateTo(3);
                                        },
                                        child: Text(
                                          state.providerDetails.companyName ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.blackColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomInkWellContainer(
                                        onTap: () => _tabController.animateTo(1),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: List.generate(5, (final int index) {
                                                final double starRating =
                                                    double.parse(state.providerDetails.ratings!);
                                                if (index < starRating) {
                                                  return Icon(
                                                    Icons.star,
                                                    color: AppColors.ratingStarColor,
                                                  );
                                                }
                                                return Icon(
                                                  Icons.star,
                                                  color:
                                                      Theme.of(context).colorScheme.lightGreyColor,
                                                );
                                              }),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              state.providerDetails.numberOfRatings!,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.blackColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              " ${"reviewers".translate(context: context)}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context).colorScheme.lightGreyColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          maxHeight: 50,
                          minHeight: 50,
                          child: Container(
                            color: Theme.of(context).colorScheme.secondaryColor,
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: Theme.of(context).colorScheme.accentColor,
                              unselectedLabelColor: Theme.of(context).colorScheme.lightGreyColor,
                              labelColor: Theme.of(context).colorScheme.accentColor,
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              indicatorPadding: const EdgeInsets.only(bottom: 5),
                              tabs: tabLabels
                                  .map(
                                    (e) => Tab(
                                      text: e.translate(context: context),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      )
                    ],
                    body: TabBarView(
                      controller: _tabController,
                      children: [
                        ProviderServicesContainer(
                          isProviderAvailableAtLocation:
                              state.providerDetails.isAvailableAtLocation!,
                          servicesList: state.serviceList,
                          providerID: state.providerDetails.providerId ?? "0",
                          isLoadingMoreData: state.isLoadingMoreServices,
                        ),
                        SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: context.read<CartCubit>().getProviderIDFromCartData() == '0'
                                ? 0
                                : bottomNavigationBarHeight + 10,
                          ),
                          child: BlocBuilder<ReviewCubit, ReviewState>(
                            builder: (context, reviewState) {
                              if (reviewState is ReviewFetchFailure) {
                                return ErrorContainer(
                                  errorMessage:
                                      reviewState.errorMessage.translate(context: context),
                                  onTapRetry: () {
                                    context.read<ReviewCubit>().fetchReview(
                                          providerId: state.providerDetails.providerId ?? "0",
                                        );
                                  },
                                );
                              } else if (reviewState is ReviewFetchSuccess) {
                                //

                                if (reviewState.reviewList.isEmpty) {
                                  return Center(
                                    child: NoDataContainer(
                                      titleKey: "noReviewsFound".translate(context: context),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryColor,
                                    borderRadius: BorderRadius.circular(borderRadiusOf10),
                                  ),
                                  child: ReviewsContainer(
                                    listOfReviews: reviewState.reviewList,
                                    totalNumberOfRatings:
                                        state.providerDetails.numberOfRatings ?? "0",
                                    averageRating: state.providerDetails.ratings ?? "0",
                                    totalNumberOfFiveStarRating:
                                        state.providerDetails.fiveStar ?? "0",
                                    totalNumberOfFourStarRating:
                                        state.providerDetails.fourStar ?? "0",
                                    totalNumberOfThreeStarRating:
                                        state.providerDetails.threeStar ?? "0",
                                    totalNumberOfTwoStarRating:
                                        state.providerDetails.twoStar ?? "0",
                                    totalNumberOfOneStarRating:
                                        state.providerDetails.oneStar ?? "0",
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  ),
                                );
                              }
                              return ShimmerLoadingContainer(
                                child: CustomShimmerContainer(
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  height: 25,
                                  borderRadius: borderRadiusOf15,
                                ),
                              );
                            },
                          ),
                        ),
                        if (context.read<AuthenticationCubit>().state is UnAuthenticatedState) ...[
                          Center(
                            child: NoDataContainer(
                              titleKey: 'noPromoCodeAvailable'.translate(context: context),
                            ),
                          )
                        ] else ...[
                          PromocodeContainer(providerId: state.providerDetails.providerId ?? "0"),
                        ],
                        AboutProviderContainer(providerDetails: state.providerDetails)
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    start: MediaQuery.sizeOf(context).width * 0.01,
                    end: MediaQuery.sizeOf(context).width * 0.01,
                    bottom: 0,
                    child: CartSubDetails(
                      providerID: state.providerDetails.providerId,
                    ),
                  ),
                ],
              );
            }
            return providerDetailsScreenShimmerLoading();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
