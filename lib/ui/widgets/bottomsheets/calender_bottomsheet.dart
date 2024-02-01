import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class CalenderBottomSheet extends StatefulWidget {
  const CalenderBottomSheet({
    required this.providerId,
    required this.advanceBookingDays,
    final Key? key,
    this.selectedDate,
    this.selectedTime,
    this.orderId,
  }) : super(key: key);

  final String providerId;
  final String advanceBookingDays;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? orderId;

  @override
  State<CalenderBottomSheet> createState() => _CalenderBottomSheetState();
}

class _CalenderBottomSheetState extends State<CalenderBottomSheet> with TickerProviderStateMixin {
  // PageController _pageController = PageController();
  List<String> listOfMonth = [
    "january",
    "february",
    "march",
    "april",
    "may",
    "june",
    "july",
    "august",
    "september",
    "october",
    "november",
    "december"
  ];

  String? selectedMonth;
  String? selectedYear;
  late DateTime focusDate, selectedDate;
  String? selectedTime;
  String? message;
  int? selectedTimeSlotIndex;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> calenderAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-1, 0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ),
  );

  late final Animation<Offset> timeSlotAnimation = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ),
  );

  TextStyle _getDayHeadingStyle() => TextStyle(
        color: Theme.of(context).colorScheme.blackColor,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 22,
      );

  void fetchTimeSlots() {
    context
        .read<TimeSlotCubit>()
        .getTimeslotDetails(providerID: int.parse(widget.providerId), selectedDate: selectedDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    focusDate = widget.selectedDate ?? DateTime.now();
    selectedDate = widget.selectedDate ?? DateTime.now();
    selectedMonth = listOfMonth[DateTime.now().month - 1];
    selectedYear = DateTime.now().year.toString();

    Future.delayed(Duration.zero).then((final value) {
      fetchTimeSlots();
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(
            {"selectedDate": selectedDate, "selectedTime": selectedTime, "message": message},
          );
          return true;
        },
        child: SafeArea(
          child: StatefulBuilder(
            builder: (final BuildContext context, final setStater) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                children: [
                  SlideTransition(
                    position: calenderAnimation,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryColor,
                            borderRadius: BorderRadius.circular(borderRadiusOf15)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _getSelectDateHeadingWithMonthAndYear(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: _getCalender(setStater),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //   _getSelectedDateContainer(),
                            _getCloseAndTimeSlotNavigateButton()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: timeSlotAnimation,
                    child: Align(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryColor,
                            borderRadius: BorderRadius.circular(borderRadiusOf15)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getSelectTimeSlotHeadingWithDate(),
                            Expanded(
                              child: BlocConsumer<TimeSlotCubit, TimeSlotState>(
                                listener: (final context, final state) {
                                  if (state is TimeSlotFetchSuccess) {
                                    if (state.isError) {
                                      UiUtils.showMessage(
                                        context,
                                        state.message,
                                        MessageType.warning,
                                      );
                                    }
                                  }
                                },
                                builder: (final context, final state) {
                                  //timeslot background color
                                  final Color disabledTimeSlotColor =
                                      Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.35);
                                  final Color selectedTimeSlotColor =
                                      Theme.of(context).colorScheme.accentColor;
                                  final Color defaultTimeSlotColor =
                                      Theme.of(context).colorScheme.primaryColor;

                                  //timeslot border color
                                  final Color disabledTimeSlotBorderColor =
                                      Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.35);
                                  final Color selectedTimeSlotBorderColor =
                                      Theme.of(context).colorScheme.accentColor;
                                  final Color defaultTimeSlotBorderColor =
                                      Theme.of(context).colorScheme.blackColor;

                                  //timeslot text color
                                  final Color disabledTimeSlotTextColor =
                                      Theme.of(context).colorScheme.blackColor;
                                  final Color selectedTimeSlotTextColor = AppColors.whiteColors;
                                  final Color defaultTimeSlotTextColor =
                                      Theme.of(context).colorScheme.blackColor;

                                  if (state is TimeSlotFetchSuccess) {
                                    return state.isError
                                        ? Center(
                                            child: Text(state.message),
                                          )
                                        : GridView.count(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            ),
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 20,
                                            childAspectRatio: 2.7,
                                            children: List<Widget>.generate(
                                                  state.slotsData.length,
                                                  (index) {
                                                    return CustomInkWellContainer(
                                                      onTap: () {
                                                        if (state.slotsData[index].isAvailable == 0) {
                                                          return;
                                                        }

                                                        selectedTime = state.slotsData[index].time;
                                                        message = state.slotsData[index].message;
                                                        selectedTimeSlotIndex = index;
                                                        setState(() {});
                                                      },
                                                      child: slotItemContainer(
                                                        backgroundColor:
                                                            state.slotsData[index].isAvailable == 0
                                                                ? disabledTimeSlotColor
                                                                : selectedTimeSlotIndex == index
                                                                    ? selectedTimeSlotColor
                                                                    : defaultTimeSlotColor,
                                                        borderColor:
                                                            state.slotsData[index].isAvailable == 0
                                                                ? disabledTimeSlotBorderColor
                                                                : selectedTimeSlotIndex == index
                                                                    ? selectedTimeSlotBorderColor
                                                                    : defaultTimeSlotBorderColor,
                                                        titleColor:
                                                            state.slotsData[index].isAvailable == 0
                                                                ? disabledTimeSlotTextColor
                                                                : selectedTimeSlotIndex == index
                                                                    ? selectedTimeSlotTextColor
                                                                    : defaultTimeSlotTextColor,
                                                        title: (state.slotsData[index].time ?? "")
                                                            .formatTime(),
                                                      ),
                                                    );
                                                  },
                                                ) +
                                                <Widget>[
                                                  CustomInkWellContainer(
                                                    onTap: () {
                                                      displayTimePicker(context);
                                                    },
                                                    child: slotItemContainer(
                                                        backgroundColor: Colors.transparent,

                                                        titleColor: Theme.of(context)
                                                            .colorScheme
                                                            .accentColor,
                                                        borderColor: Theme.of(context)
                                                            .colorScheme
                                                            .accentColor,
                                                        title: selectedTime ??
                                                            "addSlot".translate(context: context)),
                                                  )
                                                ],
                                          );
                                  }
                                  if (state is TimeSlotFetchFailure) {
                                    return ErrorContainer(
                                      onTapRetry: () {
                                        fetchTimeSlots();
                                      },
                                      errorMessage: state.errorMessage.translate(context: context),
                                    );
                                  }
                                  return Center(
                                    child: Text("loading".translate(context: context)),
                                  );
                                },
                              ),
                            ),
                            //   _getSelectedCustomTimeSlotContainer(),
                            _getBackAndContinueNavigateButton()
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget slotItemContainer({
    required Color backgroundColor,
    required Color borderColor,
    required Color titleColor,
    required String title,
  }) {
    return Container(
      width: 150,
      height: 20,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(borderRadiusOf20),
        ),
        border: Border.all(
          width: 0.5,
          color: borderColor,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
      ),
    );
  }

//
  Future displayTimePicker(final BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = "${time.hour}:${time.minute}:00".convertTime();
        selectedTimeSlotIndex = null;
      });
    }
  }

  //
  Widget _getSelectedCustomTimeSlotContainer() => Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf15)),
          color: Theme.of(context).colorScheme.secondaryColor,
        ),
        child: Center(
          child: CustomInkWellContainer(
            onTap: () {
              displayTimePicker(context);
            },
            child: Text(
              selectedTime != null
                  ? (selectedTime ?? "").formatTime()
                  : 'checkOnCustomTime'.translate(context: context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );

  Widget _getSelectTimeSlotHeadingWithDate() {
    final String monthName = listOfMonth[selectedDate.month - 1];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(borderRadiusOf20),
          topRight: Radius.circular(borderRadiusOf20),
        ),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Text(
            "selectTimeSlot".translate(context: context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                  border: Border.all(color: Theme.of(context).colorScheme.blackColor),
                ),
                height: 30,
                width: 110,
                child: Center(
                  child: Text(
                    selectedDate.toString().split(" ").first.formatDate(),
                    //'${selectedDate.day}-$monthName-${selectedDate.year}',
                    textDirection: TextDirection.ltr,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectDateHeadingWithMonthAndYear() => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(borderRadiusOf20),
            topRight: Radius.circular(borderRadiusOf20),
          ),
        ),
        child: Row(
          children: [
            Text(
              'selectDate'.translate(context: context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                    border: Border.all(color: Theme.of(context).colorScheme.blackColor),
                  ),
                  height: 30,
                  width: 70,
                  child: Center(
                      child: Text(
                    "$selectedMonth".translate(context: context),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                  )),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf10)),
                    border: Border.all(color: Theme.of(context).colorScheme.blackColor),
                  ),
                  height: 30,
                  width: 70,
                  child: Center(child: Text("$selectedYear")),
                ),
                //
              ],
            )
          ],
        ),
      );

  Widget _getCalender(final StateSetter setStater) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: TableCalendar(
          onCalendarCreated: (final PageController pageController) {
            //   _pageController = pageController;
          },
          headerVisible: false,
          currentDay: selectedDate,
          onPageChanged: (final DateTime date) {
            //
            //add 0, if month is 1,2,3...9, to make it as 01,02...09 digit
            final newIndex = (date.month).toString().padLeft(2, '0');

            selectedYear = date.year.toString();
            selectedMonth = listOfMonth[date.month - 1];
            //we are adding first date of month as focusDate
            focusDate = DateTime.parse('$selectedYear-$newIndex-01 00:00:00.000Z');
            //
            //If focus date is before of current date then we will add current date as focus date
            if (focusDate.isBefore(DateTime.now())) {
              focusDate = DateTime.now();
            }
            setState(() {});
          },
          onDaySelected: (final DateTime date, final DateTime date1) {
            //  focusDate = DateTime.parse(date.toString());
            selectedDate = DateTime.parse(date.toString());
            setStater(() {});
            fetchTimeSlots();
          },
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: int.parse(widget.advanceBookingDays))),
          focusedDay: focusDate,
          daysOfWeekHeight: 50,
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (final DateTime date, final locale) =>
                intl.DateFormat.E(locale).format(date)[0],
            weekendStyle: _getDayHeadingStyle(),
            weekdayStyle: _getDayHeadingStyle(),
          ),
        ),
      );

  Widget _getSelectedDateContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(borderRadiusOf15)),
        color: Theme.of(context).colorScheme.secondaryColor,
      ),
      child: Center(
        child: Text(
          selectedDate.toString().split(" ").first.formatDate(),

          //   "${selectedDate.day}-$monthName-${selectedDate.year}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.blackColor,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }

  Row _getCloseAndTimeSlotNavigateButton() => Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: CustomInkWellContainer(
              onTap: () {
                Navigator.of(context).pop(
                  {"selectedDate": selectedDate, "selectedTime": selectedTime, "message": message},
                );
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1c343f53),
                      offset: Offset(0, -3),
                      blurRadius: 10,
                    )
                  ],
                  color: Theme.of(context).colorScheme.secondaryColor,
                ),
                child: Center(
                  child: Text(
                    'close'.translate(context: context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomInkWellContainer(
              onTap: () {
                _controller.forward();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1c343f53),
                      offset: Offset(0, -3),
                      blurRadius: 10,
                    )
                  ],
                  color: Theme.of(context).colorScheme.accentColor,
                ),
                child: Center(
                  child: Text(
                    'selectTimeSlot'.translate(context: context),
                    style: TextStyle(
                      color: AppColors.whiteColors,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );

  Row _getBackAndContinueNavigateButton() => Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: CustomInkWellContainer(
              onTap: () {
                _controller.reverse();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1c343f53),
                      offset: Offset(0, -3),
                      blurRadius: 10,
                    )
                  ],
                  color: Theme.of(context).colorScheme.secondaryColor,
                ),
                child: Center(
                  child: Text(
                    'back'.translate(context: context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<ValidateCustomTimeCubit, ValidateCustomTimeState>(
              listener: (
                final BuildContext context,
                final ValidateCustomTimeState validateCustomTimeState,
              ) {
                if (validateCustomTimeState is ValidateCustomTimeSuccess) {
                  if (!validateCustomTimeState.error) {
                    Navigator.of(context).pop(
                      {
                        "selectedDate": selectedDate,
                        "selectedTime": selectedTime,
                        "message": message
                      },
                    );
                  } else {
                    selectedTime= null;
                    UiUtils.showMessage(
                        context,
                        validateCustomTimeState.message.translate(context: context),
                        MessageType.error);
                  }
                } else if (validateCustomTimeState is ValidateCustomTimeFailure) {
                  UiUtils.showMessage(
                    context,
                    validateCustomTimeState.errorMessage.translate(context: context),
                    MessageType.error,
                  );
                  selectedTime=null;
                  setState(() {

                  });
                }
              },
              builder: (context, validateCustomTimeState) {
                Widget? child;
                if (validateCustomTimeState is ValidateCustomTimeInProgress) {
                  child = CircularProgressIndicator(color: AppColors.whiteColors);
                } else if (validateCustomTimeState is ValidateCustomTimeFailure ||
                    validateCustomTimeState is ValidateCustomTimeSuccess) {
                  child = null;
                }
                return CustomInkWellContainer(
                  onTap: () {
                    context.read<ValidateCustomTimeCubit>().validateCustomTime(
                          providerId: widget.providerId,
                          selectedDate: intl.DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse("$selectedDate"))
                              .toString(),
                          selectedTime: selectedTime.toString(),
                          orderId: widget.orderId,
                        );
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1c343f53),
                          offset: Offset(0, -3),
                          blurRadius: 10,
                        )
                      ],
                      color: Theme.of(context).colorScheme.accentColor,
                    ),
                    child: Center(
                      child: child ??
                          Text(
                            'continue'.translate(context: context),
                            style: TextStyle(
                              color: AppColors.whiteColors,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                            ),
                          ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      );
}
