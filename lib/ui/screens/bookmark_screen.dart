import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';// ignore_for_file: file_names

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({final Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(builder: (final BuildContext context) => const BookmarkScreen(),);
}

class _BookmarkScreenState extends State<BookmarkScreen> {
//
  final ScrollController _scrollController = ScrollController();

  void fetchBookmark() {
    context.read<BookmarkCubit>().fetchBookmark(type: 'list');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((final value) {
      //fetchBookmark();
    });

    _scrollController.addListener(() {
      if (!context.read<BookmarkCubit>().hasMoreBookMark()) {
        return;
      }

// nextPageTrigger will have a value equivalent to 70% of the list size.
      final nextPageTrigger = 0.7 * _scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
      if (_scrollController.position.pixels > nextPageTrigger) {
        if (mounted) {
          context.read<BookmarkCubit>().fetchMoreBookmark(type: "list");
        }
      }
    });
  }

  @override
  void dispose() {

    _scrollController.dispose();  super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: 'bookmark'.translate(context: context),
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: BlocConsumer<BookmarkCubit, BookmarkState>(
          listener: (final BuildContext context, final BookmarkState bookmarkState) {
            if (bookmarkState is BookmarkFetchFailure) {
              UiUtils.showMessage(context, bookmarkState.errorMessage.translate(context: context),
                  MessageType.error,);
            } else if (bookmarkState is BookmarkFetchSuccess) {}
          },
          builder: (final BuildContext context, final BookmarkState bookmarkState) {
            if (bookmarkState is BookmarkFetchFailure) {
              return Center(
                  child: ErrorContainer(
                errorMessage: bookmarkState.errorMessage.translate(context: context),
                onTapRetry: (){
                  fetchBookmark();
                  },
                showRetryButton: true,
              ),);
            } else if (bookmarkState is BookmarkFetchSuccess) {
              if (bookmarkState.bookmarkList.isEmpty) {
                return NoDataContainer(
                  titleKey: 'noBookmarkFound'.translate(context: context),
                );
              }
              return _getProviderList(
                  providerList: bookmarkState.bookmarkList,
                  isLoadingMoreData: bookmarkState.isLoadingMoreData,);
            }

            return const SingleChildScrollView(child: ProviderListShimmerEffect(
              showTotalProviderContainer: false,
            ));
          },
        ),
      ),
    );

  Widget _getProviderList(
      {required final List<Providers> providerList, required final bool isLoadingMoreData,}) => ListView.builder(
        padding: const EdgeInsets.all(10),
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: providerList.length + (isLoadingMoreData ? 1 : 0),
        itemBuilder: (final BuildContext context, final int index) {
          if (index >= providerList.length) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ProviderList(
            providerDetails: providerList[index],
          );
        },);
}
