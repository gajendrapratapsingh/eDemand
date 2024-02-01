import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CategoryType { category, subcategory }

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({
    required this.categoryId,
    required this.appBarTitle,
    final Key? key,
    this.subCategoryId,
  }) : super(key: key);
  final String categoryId;
  final String? subCategoryId;
  final String appBarTitle;

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();

  static Route route(final RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final _) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (final context) => SubCategoryAndProviderCubit(
              providerRepository: ProviderRepository(),
              subCategoryRepository: SubCategoryRepository(),
            ),
          ),
          BlocProvider(
            create: (final context) => ProviderCubit(ProviderRepository()),
          ),
        ],
        child: Builder(
          builder: (final BuildContext context) => SubCategoryScreen(
            categoryId: arguments["categoryId"],
            appBarTitle: arguments["appBarTitle"],
            subCategoryId: arguments["subCategoryId"],
          ),
        ),
      ),
    );
  }
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  String sortByDefaultOptionValue = 'popularity';
  late String sortByDefaultOptionName = "popularity".translate(context: context);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((final value) => fetchSubCategoryAndProviderData());
    super.initState();
  }

  void fetchSubCategoryAndProviderData() {
    context.read<SubCategoryAndProviderCubit>().getSubCategoriesAndProviderList(
          subCategoryID: widget.subCategoryId,
          categoryID: widget.categoryId,
          providerSortBy: sortByDefaultOptionValue,
        );
  }

  Widget _getSubCategoryShimmerEffect() => Padding(
        padding: const EdgeInsetsDirectional.only(top: 10, start: 10, end: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              numberOfShimmerContainer,
              (final int index) => Column(
                children: [
                  const ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      borderRadius: borderRadiusOf50,
                    ),
                  ),
                  ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      height: MediaQuery.sizeOf(context).height * 0.01,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: widget.appBarTitle,
        ),
        //bottomNavigationBar: _getsortByAndFilterByContainer(),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: BlocBuilder<SubCategoryAndProviderCubit, SubCategoryAndProviderState>(
                builder: (final BuildContext context,
                    final SubCategoryAndProviderState subCategoryAndProviderState) {
                  if (subCategoryAndProviderState is SubCategoryAndProviderFetchFailure) {
                    return ErrorContainer(
                      errorMessage:
                          subCategoryAndProviderState.errorMessage.translate(context: context),
                      onTapRetry: () {
                        fetchSubCategoryAndProviderData();
                      },
                    );
                  } else if (subCategoryAndProviderState is SubCategoryAndProviderFetchSuccess) {
                    //
                    // If subCategory and provider list is empty then show No Data found message
                    if (subCategoryAndProviderState.subCategoryList.isEmpty &&
                        subCategoryAndProviderState.providerList.isEmpty) {
                      return NoDataContainer(titleKey: 'noProvidersFound'.translate(context: context));
                    }
                    return _getSubCategoryAndProviderList(
                      subCategoryAndProviderState.subCategoryList,
                      subCategoryAndProviderState.providerList,
                      subCategoryAndProviderState.providerList.length.toString(),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _getSubCategoryShimmerEffect(),
                        const ProviderListShimmerEffect(showTotalProviderContainer: true),
                      ],
                    ),
                  );
                },
              ),
            ),
            BlocConsumer<ProviderCubit, ProviderState>(
              listener: (final BuildContext context, final ProviderState state) {
                if (state is ProviderFetchSuccess) {
                  context.read<SubCategoryAndProviderCubit>().emitSuccessState(
                        providerList: state.providerList,
                        totalProviders: state.totalProviders,
                      );
                }
              },
              builder: (final BuildContext context, final ProviderState state) {
                if (state is ProviderFetchInProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.accentColor,
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      );

  Widget _getSubCategoryList(final List<SubCategory> subCategoryList) => ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: subCategoryList.length,
        itemBuilder: (final BuildContext context, final int index) =>
            _getSubCategoryItem(subCategoryList[index]),
      );

  Widget _getSubCategoryItem(final SubCategory subCategoryList) {
    final darkModeColor = subCategoryList.darkBackgroundColor == ""
        ? Theme.of(context).colorScheme.secondaryColor
        : subCategoryList.darkBackgroundColor!.toColor();
    final lightModeColor = subCategoryList.lightBackgroundColor == ""
        ? Theme.of(context).colorScheme.secondaryColor
        : subCategoryList.lightBackgroundColor!.toColor();
    //
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? lightModeColor : darkModeColor,
        borderRadius: BorderRadius.circular(borderRadiusOf10),
      ),
      padding: const EdgeInsetsDirectional.only(
        top: 10,
        start: 10,
        end: 10,
      ),
      margin: const EdgeInsetsDirectional.only(
        top: 10,
        start: 10,
      ),
      child: ImageWithText(
        imageURL: subCategoryList.categoryImage!,
        title: subCategoryList.name!,
        imageContainerHeight: 100,
        imageContainerWidth: 100,
        imageRadius: 50,
        textContainerHeight: 50,
        textContainerWidth: 100,
        maxLines: 2,
        lightModeBackgroundColor: subCategoryList.lightBackgroundColor,
        darkModeBackgroundColor: subCategoryList.darkBackgroundColor,
        onTap: () {
          Navigator.pushNamed(
            context,
            subCategoryRoute,
            arguments: {
              'subCategoryId': subCategoryList.id,
              'categoryId': '',
              'appBarTitle': subCategoryList.name,
              'type': CategoryType.subcategory
            },
          );
        },
      ),
    );
  }

  Widget _getSubCategoryAndProviderList(
    final List<SubCategory> subCategoryList,
    final List<Providers> providerList,
    final String totalProviders,
  ) =>
      LayoutBuilder(
        builder: (final BuildContext context, final BoxConstraints constraints) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subCategoryList.isNotEmpty)
              SizedBox(height: 175, child: _getSubCategoryList(subCategoryList)),
            if (providerList.isNotEmpty)
              Expanded(child: _getProviderList(providerList, totalProviders)),
          ],
        ),
      );

  void onChangedFunc({required final String sortBySelectedOption}) {
//
    if (sortBySelectedOption == "popularity") {
      sortByDefaultOptionName = "popularity".translate(context: context);
    } else if (sortBySelectedOption == "discount") {
      sortByDefaultOptionName = "discountHighToLow".translate(context: context);
    } else if (sortBySelectedOption == "ratings") {
      sortByDefaultOptionName = "topRated".translate(context: context);
    }
    setState(() {});
    //
    context.read<ProviderCubit>().getProviders(
          categoryID: widget.categoryId,
          subCategoryID: widget.subCategoryId,
          filter: sortBySelectedOption,
        );
    /*context.read<SubCategoryAndProviderCubit>().fetchProviderList(
        categoryID: widget.categoryId,
        subCategoryID: widget.subCategoryId,
        providerSortBy: sortBySelectedOption,
        subCategoryList: context.read<SubCategoryAndProviderCubit>().getSubCategoryList());*/
  }

  Widget _getTotalProviderAndViewOptionsContainer({
    required final String totalProviders,
    required final BuildContext context,
    required final String catId,
    required final Function(String selectedOption) onChanged,
    final String? subCatId,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'provider'.translate(context: context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "$totalProviders ${"serviceProvider".translate(context: context)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.blackColor,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
            const Spacer(),
            CustomInkWellContainer(
              onTap: () {
                UiUtils.showBottomSheet(
                  context: context,
                  enableDrag: true,
                  child: SortByBottomSheet(
                    subCatId,
                    catId: catId,
                    onChanged: onChanged,
                    selectedItem: sortByDefaultOptionName,
                  ),
                );
              },
              child: Icon(Icons.sort, color: Theme.of(context).colorScheme.accentColor),
            )
          ],
        ),
      );

  Widget _getProviderList(final List<Providers> providerList, final String totalProviders) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTotalProviderAndViewOptionsContainer(
              totalProviders: totalProviders,
              context: context,
              catId: widget.categoryId,
              subCatId: widget.subCategoryId,
              onChanged: (selectedOption) {
                onChangedFunc(sortBySelectedOption: selectedOption);
              },
            ),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: providerList.length,
                itemBuilder: (final BuildContext context, final int index) => ProviderList(
                  providerDetails: providerList[index],
                  categoryId: widget.categoryId,
                ),
              ),
            ),
          ],
        ),
      );

}
