import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/ui/widgets/addNewAddressContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // ignore_for_file: prefer_typing_uninitialized_variables
import 'package:intl/intl.dart' as intl;

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    required this.companyName,
    required this.providerAdvanceBookingDays,
    required this.providerName,
    required this.providerId,
    final Key? key,
    required this.isFrom,
    this.orderID,
  }) : super(key: key);

  //
  final String providerName;
  final String isFrom;
  final String providerId;
  final String companyName;
  final String providerAdvanceBookingDays;
  final String? orderID;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();

  static Route route(final RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final BuildContext context) => Builder(
        builder: (final context) => MultiBlocProvider(
          providers: [
            BlocProvider<ValidateCustomTimeCubit>(
              create: (context) => ValidateCustomTimeCubit(cartRepository: CartRepository()),
            ),
            BlocProvider<CheckProviderAvailabilityCubit>(
              create: (final BuildContext context) =>
                  CheckProviderAvailabilityCubit(providerRepository: ProviderRepository()),
            )
          ],
          child: ScheduleScreen(
            orderID: arguments["orderID"],
            companyName: arguments["companyName"],
            isFrom: arguments["isFrom"],
            providerName: arguments['providerName'],
            providerId: arguments['providerId'],
            providerAdvanceBookingDays: arguments['providerAdvanceBookingDays'],
          ),
        ),
      ),
    );
  }
}

class _ScheduleScreenState extends State<ScheduleScreen> with ChangeNotifier {
  int? selectedAddressIndex;
  GetAddressModel? selectedAddress;
  dynamic selectedDate, selectedTime;
  String? message;

  final TextEditingController _instructionController = TextEditingController();

  late final List<Map<String, String>> deliverableOptions = [
    {"title": 'atHome', "description": 'atHomeDescription', "image": "home.svg"},
    {"title": 'atStore', "description": 'atStoreDescription', "image": "store.svg"},
  ];
  late String selectedDeliverableOption = deliverableOptions[0]['title']!;

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<GetAddressCubit>().fetchAddress();

    selectedDeliverableOption =
        context.read<CartCubit>().checkAtDoorstepProviderAvailable(isFrom: widget.isFrom)
            ? deliverableOptions[0]['title']!
            : deliverableOptions[1]['title']!;
  }

  Padding getHeadingWriteInstruction() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'writeInstructionsForProvider'.translate(context: context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
      );

  Padding getServiceDeliveryHeading() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'chooseStoreOrDoorstepOption'.translate(context: context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
      );

  Widget getServiceDeliverableOptions() {
    return Column(
      children: List.generate(
        deliverableOptions.length,
        (index) => CustomInkWellContainer(
          onTap: () {
            selectedDeliverableOption = deliverableOptions[index]["title"]!;
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsetsDirectional.symmetric(vertical: 5),
            decoration: selectedDeliverableOption == deliverableOptions[index]["title"]!
                ? selectedItemBorderStyle()
                : normalBoxDecoration(),
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CustomSvgPicture(
                    svgImage: deliverableOptions[index]["image"]!,
                    color: Theme.of(context).colorScheme.accentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        deliverableOptions[index]["title"]!.translate(context: context),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        deliverableOptions[index]["description"]!.translate(context: context),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.lightGreyColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding getHeadingDeliveryAddress() => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          'deliveryAddress'.translate(context: context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
      );

  Widget getHeadingTimeSelector() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'scheduleTime'.translate(context: context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.blackColor,
          ),
        ),
      );

  Widget getHeadingDateSelector() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'scheduleDateAndTime'.translate(context: context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.blackColor,
          ),
          textDirection: TextDirection.ltr,
        ),
      );

  Widget buildProviderInstructionField() => TextFormField(
        controller: _instructionController,
        style: const TextStyle(fontSize: 12),
        minLines: 4,
        maxLines: 5,
        textInputAction: TextInputAction.newline,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondaryColor,
          hintText: 'writeDescriptionForProvider'.translate(context: context),
          hintStyle: const TextStyle(fontSize: 12.6),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryColor, width: 2),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondaryColor),
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
        ),
      );

  Widget buildAddressSelector() => BlocListener<AddAddressCubit, AddAddressState>(
        listener: (final BuildContext context, final AddAddressState addAddressState) {
          if (addAddressState is AddAddressSuccess) {
            final getAddressModel = GetAddressModel.fromJson(addAddressState.result["data"][0]);
            context.read<AddressesCubit>().addAddress(getAddressModel);
          }
        },
        child: BlocListener<DeleteAddressCubit, DeleteAddressState>(
          listener: (final BuildContext context, final DeleteAddressState state) {
            if (state is DeleteAddressSuccess) {
              context.read<AddressesCubit>().removeAddress(state.id);
            }
          },
          child: BlocConsumer<GetAddressCubit, GetAddressState>(
            listener: (final BuildContext context, final GetAddressState getAddressState) {
              if (getAddressState is GetAddressSuccess) {
                for (var i = 0; i < getAddressState.data.length; i++) {
                  //we will make default address as selected address
                  //so we will take index of selected address and address data
                  if (getAddressState.data[i].isDefault == "1") {
                    selectedAddressIndex = i + 1;
                    selectedAddress = getAddressState.data[i];
                    setState(() {});
                  }
                }

                context.read<AddressesCubit>().load(getAddressState.data);
              }
            },
            builder: (final BuildContext context, final GetAddressState getAddressState) {
              if (getAddressState is GetAddressInProgress) {
                return SizedBox(
                  height: 140,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: ShimmerLoadingContainer(
                          child: CustomShimmerContainer(
                            height: 140,
                            width: 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ShimmerLoadingContainer(
                          child: CustomShimmerContainer(
                            height: 140,
                            width: 250,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: ShimmerLoadingContainer(
                          child: CustomShimmerContainer(
                            height: 140,
                            width: 250,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (getAddressState is GetAddressSuccess) {
                //inserting because there are Plus Button in ListView at 0 index

                if (getAddressState.data.isNotEmpty) {
                  if (getAddressState.data[0].id != null) {
                    getAddressState.data.insert(0, GetAddressModel.fromJson({}));
                  }
                }

                return BlocBuilder<AddressesCubit, AddressesState>(
                  builder: (final context, AddressesState addressesState) {
                    if (addressesState is Addresses) {
                      return getAddressState.data.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: AddAddressContainer(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    googleMapRoute,
                                    arguments: {
                                      'useStoredCordinates': true,
                                      'googleMapButton': GoogleMapButton.completeAddress
                                    },
                                  ).then((final Object? value) {
                                    context.read<GetAddressCubit>().fetchAddress();
                                  });
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: addressesState.addresses.isEmpty
                                    ? 1
                                    : addressesState.addresses.length,
                                itemBuilder: (final BuildContext context, final index) {
                                  late GetAddressModel addressData;
                                  if (getAddressState.data.isNotEmpty) {
                                    addressData = addressesState.addresses[index];
                                  }

                                  if (index == 0) {
                                    return CustomInkWellContainer(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          googleMapRoute,
                                          arguments: {
                                            'useStoredCordinates': true,
                                            'googleMapButton': GoogleMapButton.completeAddress
                                          },
                                        ).then((Object? value) {
                                          context.read<GetAddressCubit>().fetchAddress();
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondaryColor,
                                          borderRadius: BorderRadius.circular(borderRadiusOf10),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Theme.of(context).colorScheme.accentColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return CustomInkWellContainer(
                                    onTap: () {
                                      selectedAddressIndex = index;
                                      selectedAddress = addressesState.addresses[index];
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width: 250,
                                        decoration: (selectedAddressIndex == null
                                            ? (addressesState.addresses[index].isDefault == '1'
                                                ? selectedItemBorderStyle()
                                                : normalBoxDecoration())
                                            : (index == selectedAddressIndex
                                                ? selectedItemBorderStyle()
                                                : normalBoxDecoration())),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${addressData.mobile}',
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .blackColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          addressData.address.toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .blackColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${addressData.area} ,${addressData.cityName}',
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .blackColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${addressData.pincode} , ${addressData.country}',
                                                          softWrap: true,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .blackColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 20,
                                                      decoration: const BoxDecoration(),
                                                      child: Align(
                                                        alignment: Alignment.topRight,
                                                        child: PopupMenuButton<int>(
                                                          padding: EdgeInsets.zero,
                                                          iconSize: 24,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .accentColor,
                                                          shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadiusDirectional.only(
                                                              topStart: Radius.circular(borderRadiusOf10),
                                                              bottomEnd: Radius.circular(borderRadiusOf10),
                                                              bottomStart: Radius.circular(borderRadiusOf10),
                                                            ),
                                                          ),
                                                          position: PopupMenuPosition.over,
                                                          onSelected: (final selected) {
                                                            if (selected == 1) {
                                                              Navigator.pushNamed(
                                                                context,
                                                                googleMapRoute,
                                                                arguments: {
                                                                  'useStoredCordinates': false,
                                                                  'place': GooglePlaceModel(
                                                                    cityName: '',
                                                                    name: '',
                                                                    placeId: '',
                                                                    latitude: addressData.lattitude
                                                                        as String,
                                                                    longitude: addressData.longitude
                                                                        as String,
                                                                  ),
                                                                  'details': addressData,
                                                                  'googleMapButton': GoogleMapButton
                                                                      .completeAddress,
                                                                },
                                                              ).then((final Object? value) {
                                                                if (value == true) {
                                                                  context
                                                                      .read<GetAddressCubit>()
                                                                      .fetchAddress();
                                                                }
                                                              });
                                                            }

                                                            if (selected == 2) {
                                                              CustomDialogBox.confirmDelete(
                                                                context,
                                                                message: 'doYouReallyWantToDelete'
                                                                    .translate(context: context),
                                                                onDeleteTap: () {
                                                                  if (selectedAddress?.id ==
                                                                      addressData.id) {
                                                                    selectedAddress = null;
                                                                    setState(() {});
                                                                  }
                                                                  context
                                                                      .read<DeleteAddressCubit>()
                                                                      .deleteAddress(
                                                                        addressData.id as String,
                                                                      );
                                                                  Navigator.pop(context);
                                                                },
                                                              );
                                                            }
                                                          },
                                                          itemBuilder:
                                                              (final BuildContext context) => [
                                                            // popupmenu item 1
                                                            PopupMenuItem(
                                                              value: 1,
                                                              // row has two child icon and text.
                                                              child: Text(
                                                                "edit".translate(context: context),
                                                                style: TextStyle(
                                                                  color: AppColors.whiteColors,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            // popupmenu item 2
                                                            PopupMenuItem(
                                                              value: 2,
                                                              // row has two child icon and text
                                                              child: Text(
                                                                "delete"
                                                                    .translate(context: context),
                                                                style: TextStyle(
                                                                  color: AppColors.whiteColors,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          offset: const Offset(0, 24),
                                                          elevation: 2,
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: Theme.of(context)
                                                                .colorScheme
                                                                .accentColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      addressData.type.toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .blackColor,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    if ((selectedAddressIndex == null &&
                                                            addressesState
                                                                    .addresses[index].isDefault ==
                                                                '1') ||
                                                        selectedAddressIndex == index)
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'deliveryAddress'
                                                                .translate(context: context),
                                                            style: TextStyle(
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .blackColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Container(
                                                            width: 25,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .accentColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(borderRadiusOf50),
                                                            ),
                                                            child: Icon(
                                                              Icons.done,
                                                              color: AppColors.whiteColors,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                              ),
                            );
                    }

                    return Container();
                  },
                );
              }
              return Container();
            },
          ),
        ),
      );

  Widget buildDateSelector() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInkWellContainer(
            onTap: () {
              setState(() {});
              UiUtils.removeFocus();
              UiUtils.showBottomSheet(
                enableDrag: true,
                context: context,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider<ValidateCustomTimeCubit>(
                      create: (context) =>
                          ValidateCustomTimeCubit(cartRepository: CartRepository()),
                    ),
                    BlocProvider(
                      create: (final BuildContext context) => TimeSlotCubit(CartRepository()),
                    ),
                  ],
                  child: CalenderBottomSheet(
                    orderId: widget.orderID,
                    advanceBookingDays: widget.providerAdvanceBookingDays,
                    providerId: widget.providerId,
                    selectedDate: selectedDate == null ? null : DateTime.parse(selectedDate),
                    selectedTime: selectedTime,
                  ),
                ),
              ).then((final value) {
                selectedDate = intl.DateFormat('yyyy-MM-dd')
                    .format(DateTime.parse("${value['selectedDate']}"));
                selectedTime = value["selectedTime"];
                message = value["message"];
                setState(() {});
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Container(
                height: 55,
                decoration: selectedDate != null && selectedTime != null
                    ? selectedItemBorderStyle()
                    : normalBoxDecoration(),
                child: Center(
                  child: Text(
                    selectedDate != null && selectedTime != null
                        ? '${selectedDate.toString().formatDate()}, ${selectedTime.toString().formatTime()}'
                        : "selectDate".translate(context: context),
                    style: TextStyle(color: Theme.of(context).colorScheme.blackColor),
                  ),
                ),
              ),
            ),
          ),
          if (message != null && message != '')
            Text(
              'orderWillBeScheduledForTheMultipleDays'.translate(context: context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.lightGreyColor,
                fontSize: 12,
              ),
            ),
        ],
      );

  BoxDecoration selectedItemBorderStyle() => BoxDecoration(
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.lightGreyColor, blurRadius: 3)],
        border: Border.all(color: Theme.of(context).colorScheme.blackColor),
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadiusOf10),
      );

  BoxDecoration normalBoxDecoration() => BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryColor,
        borderRadius: BorderRadius.circular(borderRadiusOf10),
      );

  Widget continueButtonContainer(final BuildContext context) =>
      BlocConsumer<CheckProviderAvailabilityCubit, CheckProviderAvailabilityState>(
        listener: (final context, CheckProviderAvailabilityState checkProviderAvailabilityState) {
          if (checkProviderAvailabilityState is CheckProviderAvailabilityFetchSuccess) {
            if (checkProviderAvailabilityState.error) {
              //
              UiUtils.showMessage(
                context,
                'serviceNotAvailableAtSelectedAddress'.translate(context: context),
                MessageType.warning,
              );
            } else {
              //
              context.read<ValidateCustomTimeCubit>().validateCustomTime(
                  providerId: widget.providerId,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  orderId: widget.orderID);
            }
          } else if (checkProviderAvailabilityState is CheckProviderAvailabilityFetchFailure) {
            UiUtils.showMessage(
              context,
              checkProviderAvailabilityState.errorMessage.translate(context: context),
              MessageType.error,
            );
          }
        },
        builder: (final context, CheckProviderAvailabilityState checkProviderAvailabilityState) {
          Widget? child;

          if (checkProviderAvailabilityState is CheckProviderAvailabilityFetchInProgress) {
            child = CircularProgressIndicator(
              color: AppColors.whiteColors,
            );
          } else if (checkProviderAvailabilityState is CheckProviderAvailabilityFetchFailure ||
              checkProviderAvailabilityState is CheckProviderAvailabilityFetchSuccess) {
            child = null;
          }
          return BlocConsumer<ValidateCustomTimeCubit, ValidateCustomTimeState>(
            listener: (
              final BuildContext context,
              final ValidateCustomTimeState validateCustomTimeState,
            ) {
              if (validateCustomTimeState is ValidateCustomTimeSuccess) {
                if (!validateCustomTimeState.error) {
                  Navigator.pushNamed(
                    context,
                    orderSummaryDetailsRoute,
                    arguments: {
                      "orderId": widget.orderID,
                      "isFrom": widget.isFrom,
                      "selectedAddress": selectedAddress,
                      "isAtStoreOptionSelected": selectedDeliverableOption == "atStore" ? "1" : "0",
                      "instruction": _instructionController.text.trim(),
                      "selectedDate": selectedDate,
                      "selectedTime": selectedTime
                    },
                  );
                } else {
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
              }
            },
            builder: (
              final BuildContext context,
              final ValidateCustomTimeState validateCustomTimeState,
            ) {
              if (validateCustomTimeState is ValidateCustomTimeInProgress) {
                child = CircularProgressIndicator(color: AppColors.whiteColors);
              } else if (validateCustomTimeState is ValidateCustomTimeFailure ||
                  validateCustomTimeState is ValidateCustomTimeSuccess) {
                child = null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: CustomRoundedButton(
                  onTap: () {
                    if (validateCustomTimeState is ValidateCustomTimeInProgress ||
                        checkProviderAvailabilityState
                            is CheckProviderAvailabilityFetchInProgress) {
                      return;
                    }
                    //
                    if (selectedTime == null || selectedDate == null) {
                      UiUtils.showMessage(
                        context,
                        'pleaseSelectDateAndTime'.translate(context: context),
                        MessageType.warning,
                      );
                      return;
                    }
                    //
                    if (context
                            .read<CartCubit>()
                            .checkAtDoorstepProviderAvailable(isFrom: widget.isFrom) &&
                        selectedDeliverableOption == deliverableOptions[0]["title"]) {
                      if (selectedAddress == null) {
                        UiUtils.showMessage(
                          context,
                          'pleaseSelectAddress'.translate(context: context),
                          MessageType.warning,
                        );
                      } else {
                        context.read<CheckProviderAvailabilityCubit>().checkProviderAvailability(
                              orderId: widget.orderID,
                              isAuthTokenRequired: true,
                              checkingAtCheckOut: '1',
                              latitude: selectedAddress!.lattitude.toString(),
                              longitude: selectedAddress!.longitude.toString(),
                            );
                      }
                    } else {
                      Navigator.pushNamed(
                        context,
                        orderSummaryDetailsRoute,
                        arguments: {
                          "orderId": widget.orderID,
                          "isFrom": widget.isFrom,
                          "selectedAddress": selectedAddress,
                          "isAtStoreOptionSelected":
                              selectedDeliverableOption == "atStore" ? "1" : "0",
                          "instruction": _instructionController.text.trim(),
                          "selectedDate": selectedDate,
                          "selectedTime": selectedTime
                        },
                      );
                      // context.read<ValidateCustomTimeCubit>().validateCustomTime(
                      //       providerId: widget.providerId,
                      //       selectedDate: selectedDate,
                      //       selectedTime: selectedTime,
                      //       orderId: widget.orderID,
                      //     );
                    }
                  },
                  widthPercentage: 1,
                  backgroundColor: Theme.of(context).colorScheme.accentColor,
                  buttonTitle: 'continueText'.translate(context: context),
                  showBorder: false,
                  child: child,
                ),
              );
            },
          );
        },
      );

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: UiUtils.getSimpleAppBar(
        context: context,
        title: widget.companyName,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomNavigationBarHeight + 20, top: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (context
                                .read<CartCubit>()
                                .checkAtStoreProviderAvailable(isFrom: widget.isFrom) &&
                            context
                                .read<CartCubit>()
                                .checkAtDoorstepProviderAvailable(isFrom: widget.isFrom)) ...[
                          getServiceDeliveryHeading(),
                          getServiceDeliverableOptions(),
                        ],
                        getHeadingDateSelector(),
                        buildDateSelector(),
                      ],
                    ),
                  ),
                  if (selectedDeliverableOption == deliverableOptions[0]["title"] &&
                      context
                          .read<CartCubit>()
                          .checkAtDoorstepProviderAvailable(isFrom: widget.isFrom)) ...[
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 10),
                      child: getHeadingDeliveryAddress(),
                    ),
                    buildAddressSelector(),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHeadingWriteInstruction(),
                        const SizedBox(height: 8),
                        buildProviderInstructionField()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<DeleteAddressCubit, DeleteAddressState>(
              builder: (final BuildContext context, final DeleteAddressState state) {
                if (state is DeleteAddressInProgress) {
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return Container();
              },
            ),
            Align(alignment: Alignment.bottomCenter, child: continueButtonContainer(context))
          ],
        ),
      ),
    );
  }
}
