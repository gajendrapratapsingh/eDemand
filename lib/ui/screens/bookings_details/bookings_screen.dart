// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/screens/bookings_details/bookingsList.dart';
import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({required this.scrollController, final Key? key}) : super(key: key);
  final ScrollController scrollController;

  @override
  State<BookingsScreen> createState() => BookingsScreenState();
}

class BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //
  late TabController _tabController;


//
  void fetchBookingDetails() {
    Future.delayed(Duration.zero).then((final value) {
      String status = '';
      switch (_tabController.index) {
        case 0:
          status = '';
          break;
        case 1:
          status = 'awaiting';
          break;
        case 2:
          status = 'confirmed';
          break;
        case 3:
          status = 'started';
          break;
        case 4:
          status = 'cancelled';
          break;
        case 5:
          status = 'rescheduled';
          break;
        case 6:
          status = 'completed';
          break;
      }

      final AuthenticationState authStatus = context.read<AuthenticationCubit>().state;
      if (authStatus is AuthenticatedState) {
        Future.delayed(Duration.zero).then((final value) {
          context.read<BookingCubit>().fetchBookingDetails(status: status);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();

    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        appBar: UiUtils.getSimpleAppBar(
          context: context,
          title: "myBookings".translate(context: context),
          centerTitle: true,
          isLeadingIconEnable: false,
          elevation: 0.5,
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (final context, final state) =>
              Hive.box(userDetailBoxKey).get(tokenIdKey) == null
                  ? ErrorContainer(
                      errorMessage: 'pleaseLogin'.translate(context: context),
                      showRetryButton: true,
                      buttonName: 'login',
                      onTapRetry: () {
                        Navigator.pushNamed(context, loginRoute);
                      },
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.secondaryColor,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _buildTabBar(),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              BookingsList(
                                selectedStatus: "",
                                scrollController: widget.scrollController,
                              ),
                              BookingsList(
                                selectedStatus: "awaiting",
                                scrollController: widget.scrollController,
                              ),
                              BookingsList(
                                selectedStatus: 'confirmed',
                                scrollController: widget.scrollController,
                              ),
                              BookingsList(
                                selectedStatus: 'started',
                                scrollController: widget.scrollController,
                              ),
                              BookingsList(
                                selectedStatus: 'cancelled',
                                scrollController: widget.scrollController,
                              ),
                              BookingsList(
                                selectedStatus: 'rescheduled',
                                scrollController: widget.scrollController,
                              ),
                              BookingsList(
                                selectedStatus: 'completed',
                                scrollController: widget.scrollController,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildTabBar() => TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.accentColor,
          borderRadius: BorderRadius.circular(borderRadiusOf10),
        ),
        labelColor: AppColors.whiteColors,
        unselectedLabelColor: Theme.of(context).colorScheme.lightGreyColor,
        isScrollable: true,
        tabs: [
          Tab(
            text: 'all'.translate(context: context),
          ),
          Tab(
            text: 'awaiting'.translate(context: context),
          ),
          Tab(
            text: 'confirmed'.translate(context: context),
          ),
          Tab(
            text: 'started'.translate(context: context),
          ),
          Tab(
            text: 'canceled'.translate(context: context),
          ),
          Tab(
            text: 'rescheduled'.translate(context: context),
          ),
          Tab(
            text: 'completed'.translate(context: context),
          )
        ],
      );

  @override
  bool get wantKeepAlive => true;
}
