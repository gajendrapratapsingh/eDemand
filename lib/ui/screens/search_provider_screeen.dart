// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({final Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final BuildContext context) => BlocProvider<SearchProviderCubit>(
          create: (final context) => SearchProviderCubit(ProviderRepository()),
          child: const SearchScreen(),
        ),
      );
}

class _SearchScreenState extends State<SearchScreen> {
  // search provider controller
  final TextEditingController searchProviderController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //give delay to live search
  Timer? delayTimer;

  //to check length of search text
  int previousLength = 0;

  //
  void searchProvider({required final String searchText}) {
    context.read<SearchProviderCubit>().searchProvider(searchKeyword: searchText);
  }

  //
  void searchTextListener() {
    if (searchProviderController.text.isEmpty) {
      delayTimer?.cancel();
    }

    if (delayTimer?.isActive ?? false) delayTimer?.cancel();

    delayTimer = Timer(const Duration(milliseconds: 300), () {
      if (searchProviderController.text.isNotEmpty) {
        if (searchProviderController.text.length != previousLength) {
          searchProvider(searchText: searchProviderController.text);
          //
          previousLength = searchProviderController.text.length;
        }
      } else {
        previousLength = 0;
        searchProvider(searchText: '');
      }
    });
  }

  ///
  @override
  void initState() {
    super.initState();
    searchProvider(searchText: '');
    //listen to search text change to  fetch data
    searchProviderController.addListener(searchTextListener);

    _scrollController.addListener(() {
      if (!context.read<SearchProviderCubit>().hasMoreProviders()) {
        return;
      }

// nextPageTrigger will have a value equivalent to 70% of the list size.
      final nextPageTrigger = 0.7 * _scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
      if (_scrollController.position.pixels > nextPageTrigger) {
        if (mounted) {
          context
              .read<SearchProviderCubit>()
              .fetchMoreSearchedProvider(searchKeyword: searchProviderController.text.trim());
        }
      }
    });
  }

  @override
  void dispose() {
    searchProviderController.dispose();
    _scrollController.dispose();
    delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnnotatedRegion(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: Scaffold(
          appBar: AppBar(
            leading: CustomInkWellContainer(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
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
            title: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 35.rh(context),
                child: TextField(
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.blackColor),
                  controller: searchProviderController,
                  cursorColor: Theme.of(context).colorScheme.blackColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 2, left: 15),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryColor,
                    hintText: 'searchProvider'.translate(context: context),
                    hintStyle:
                        TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.blackColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(borderRadiusOf10)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(borderRadiusOf10)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(borderRadiusOf10)),
                    ),
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(10),
                      child: CustomSvgPicture(
                        svgImage: 'search.svg',
                        height: 12,
                        width: 12,
                        color: Theme.of(context).colorScheme.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          ),
          body: BlocConsumer<SearchProviderCubit, SearchProviderState>(
            listener: (final BuildContext context, final SearchProviderState searchState) {
              if (searchState is SearchProviderFailure) {
                UiUtils.showMessage(context, searchState.errorMessage.translate(context: context),
                    MessageType.error);
              }
            },
            builder: (final BuildContext context, final SearchProviderState searchState) {
              if (searchState is SearchProviderFailure) {
                return Center(
                  child: ErrorContainer(
                    errorMessage: 'somethingWentWrong'.translate(context: context),
                    onTapRetry: () =>
                        searchProvider(searchText: searchProviderController.text.trim()),
                    showRetryButton: true,
                  ),
                );
              } else if (searchState is SearchProviderSuccess) {
                if (searchState.providerList.isEmpty) {
                  return NoDataContainer(
                    titleKey: 'noProviderFound'.translate(context: context),
                  );
                }
                return _getProviderList(
                    providerList: searchState.providerList,
                    isLoadingMoreData: searchState.isLoadingMore);
              }

              return const SingleChildScrollView(
                  child: ProviderListShimmerEffect(
                showTotalProviderContainer: false,
              ));
            },
          ),
        ),
      );

  Widget _getProviderList(
          {required final List<Providers> providerList, required final bool isLoadingMoreData}) =>
      CustomRefreshIndicator(
        onRefreshCallback: () {
          searchProvider(searchText: '');
        },
        displacment: 12,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: providerList.length + (isLoadingMoreData ? 1 : 0),
          itemBuilder: (final BuildContext context, final int index) {
            if (index >= providerList.length) {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.accentColor),
              );
            }
            return ProviderList(
              providerDetails: providerList[index],
            );
          },
        ),
      );
}
