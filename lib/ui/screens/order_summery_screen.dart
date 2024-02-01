import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/cubits/addTransactionCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSummeryScreen extends StatefulWidget {
  //
  const OrderSummeryScreen({
    required this.selectedAddress,
    required this.isAtStoreOptionSelected,
    final Key? key,
    this.selectedDate,
    this.selectedTime,
    this.instruction,
    required this.isFrom,
    required this.orderId,
  }) : super(key: key);

  //
  final String isFrom;
  final String orderId;
  final String? selectedDate;
  final String? selectedTime;
  final GetAddressModel? selectedAddress;
  final String isAtStoreOptionSelected;
  final String? instruction;

  static Route route(final RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (final context) => MultiBlocProvider(
        providers: [
          BlocProvider<PlaceOrderCubit>(
            create: (final BuildContext context) =>
                PlaceOrderCubit(cartRepository: CartRepository()),
          ),
          BlocProvider(
            create: (context) => AddTransactionCubit(bookingRepository: BookingRepository()),
          ),
          BlocProvider(
            create: (context) => ChangeBookingStatusCubit(bookingRepository: BookingRepository()),
          ),
        ],
        child: OrderSummeryScreen(
          orderId: arguments["orderId"] ?? "",
          isFrom: arguments["isFrom"],
          instruction: arguments["instruction"],
          selectedDate: arguments["selectedDate"],
          selectedTime: arguments["selectedTime"],
          selectedAddress: arguments["selectedAddress"],
          isAtStoreOptionSelected: arguments["isAtStoreOptionSelected"],
        ),
      ),
    );
  }

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  // we will get provider Id from cart cubit to fetch promoCode,  we are calling it for cart details
  String? providerId;
  String promoCodeName = '';
  double promoCodeDiscount = 0;
  PaymentGatewaysSettings? paymentGatewaySetting;
  String? placedOrderId;

  //
  ValueNotifier<String> paymentButtonName = ValueNotifier("makePayment");

  //
  //keep pay later option as last option
  // because we are checking that pay later is allowed of all service or not
  //if not allowed then we will remove last method (which should be pay later)
  late final List<Map<String, String>> paymentMethods = [
    {"title": 'payNow', "description": 'payOnlineNow', "atStoreDescription": "payOnlineNow"},
    {
      "title": 'payOnService',
      "description": 'payWithServiceAtYourHome',
      "atStoreDescription": "payWithServiceAtStore"
    },
  ];
  late String selectedPaymentMethod = paymentMethods[0]['title']!;

  ///------------------------ PayStack Payment Gateway Start ----------------------------------
  PaystackPlugin payStackPaymentGateway = PaystackPlugin();

  //initialize PayStack
  Future<void> initializePayStack() async {
    await payStackPaymentGateway.initialize(publicKey: paymentGatewaySetting!.paystackKey!);
  }

  //Using package flutter_paystack
  Future<void> openPaystackPaymentGateway({
    required final String placedOrderId,
    required final double orderAmount,
    required final String emailId,
  }) async {
    final charge = Charge()
      ..amount = (orderAmount * 100).toInt()
      ..reference = _getReference()
      ..email = emailId
      ..currency = paymentGatewaySetting!.paystackCurrency
      ..putMetaData('order_id', placedOrderId);

    final CheckoutResponse response = await payStackPaymentGateway.checkout(
      context,
      logo: SvgPicture.asset("$imagePath/splash_logo.svg", width: 50, height: 50),
      method: CheckoutMethod.card,
      // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status) {
      navigateToOrderConfirmation(
        isSuccess: true,
      );
    } else {
      navigateToOrderConfirmation(
        isSuccess: false,
      );
    }
  }

  //
  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  //----------------------------------- Paystack Payment Gateway end ----------------------------

  //----------------------------------- Razorpay Payment Gateway Start ----------------------------
  final Razorpay _razorpay = Razorpay();

  void initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
  }

  void _handleRazorPayPaymentSuccess(final PaymentSuccessResponse response) {
    navigateToOrderConfirmation(isSuccess: true);
  }

  void _handleRazorPayPaymentError(final PaymentFailureResponse response) {
    navigateToOrderConfirmation(isSuccess: false);
  }

  void _handleRazorPayExternalWallet(final ExternalWalletResponse response) {}

  Future<void> openRazorPayGateway({
    required final double orderAmount,
    required final String placedOrderId,
    required final String razorpayOrderId,
  }) async {
    final options = <String, Object?>{
      'key': paymentGatewaySetting!.razorpayKey, //this should be come from server
      'amount': (orderAmount * 100).toInt(),
      'name': appName,
      'description': '',
      'currency': paymentGatewaySetting!.razorpayCurrency,
      'notes': {'order_id': placedOrderId},
      'order_id': razorpayOrderId,
    };

    _razorpay.open(options);
  }

  //----------------------------------- Razorpay Payment Gateway End ----------------------------

  //----------------------------------- Stripe Payment Gateway Start ----------------------------

  Future<void> openStripePaymentGateway({
    required final double orderAmount,
    required final String placedOrderId,
  }) async {
    try {
      StripeService.secret = paymentGatewaySetting!.stripeSecretKey;
      StripeService.init(
        paymentGatewaySetting!.stripePublishableKey,
        paymentGatewaySetting!.stripeMode,
      );

      final response = await StripeService.payWithPaymentSheet(
        amount: (orderAmount * 100).toInt(),
        currency: paymentGatewaySetting!.stripeCurrency,
        isTestEnvironment: paymentGatewaySetting!.stripeMode == "test",
        awaitedOrderId: placedOrderId,
        from: 'order',
      );

      if (response.status == 'succeeded') {
        navigateToOrderConfirmation(isSuccess: true);
      } else {
        navigateToOrderConfirmation(isSuccess: false);
      }
    } catch (_) {}
  }

  //----------------------------------- Stripe Payment Gateway End ----------------------------

  void navigateToOrderConfirmation({required final bool isSuccess}) {
    if (!isSuccess) {
      paymentButtonName.value = "rePayment";
      UiUtils.showMessage(
          context, "bookingFailureMessage".translate(context: context), MessageType.error);
      //
      context
          .read<AddTransactionCubit>()
          .addTransaction(status: "cancelled", orderID: placedOrderId ?? "0");
      //

      context.read<BookingCubit>().fetchBookingDetails(status: "");
      //   context.read<CartCubit>().getCartDetails(isReorderCart: false);
      return;
    }

    Navigator.pushNamed(
      context,
      orderConfirmation,
      arguments: {'isSuccess': isSuccess, "orderId": placedOrderId},
    );
  }

  void getProviderId() {
    Future.delayed(Duration.zero)
        .then((final value) => providerId = context.read<CartCubit>().getProviderIDFromCartData());
  }

  void getPaymentGatewaySetting() {
    paymentGatewaySetting = context.read<SystemSettingCubit>().getPaymentMethodSettings();
  }

  @override
  void initState() {
    super.initState();
    getPaymentGatewaySetting();
    getProviderId();
    initializeRazorpay();
    initializePayStack();
  }

  @override
  void dispose() {
    paymentButtonName.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (context.read<PlaceOrderCubit>().state is PlaceOrderInProgress) {
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          appBar: UiUtils.getSimpleAppBar(
            context: context,
            title: 'orderSummary'.translate(context: context),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: bottomNavigationBarHeight + 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'dateAndTime'.translate(context: context),
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.rh(context),
                            ),
                            customOrderSummeryTile(
                              context,
                              title: widget.selectedDate.toString().formatDate(),
                              subtitle: widget.selectedTime.toString().formatTime(),
                              isMultipleText: true,
                              leadingIcon: CustomSvgPicture(
                                svgImage: 'calender.svg',
                                color: Theme.of(context).colorScheme.accentColor,
                              ),
                            ),
                            SizedBox(
                              height: 10.rh(context),
                            ),
                            if (widget.selectedAddress != null &&
                                widget.isAtStoreOptionSelected != "1") ...[
                              Text(
                                'address'.translate(context: context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                              customOrderSummeryTile(
                                context,
                                title:
                                    '${widget.selectedAddress?.mobile} \n ${widget.selectedAddress?.address}, ${widget.selectedAddress?.area}, ${widget.selectedAddress?.cityName},${widget.selectedAddress?.state} ${widget.selectedAddress?.pincode}',
                                leadingIcon: CustomSvgPicture(
                                  svgImage: 'address.svg',
                                  color: Theme.of(context).colorScheme.accentColor,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                            ],
                            if (widget.isAtStoreOptionSelected == "1") ...[
                              Text(
                                'selectServiceDeliverable'.translate(context: context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                              customOrderSummeryTile(
                                context,
                                title: widget.isAtStoreOptionSelected == "1"
                                    ? "atStore".translate(context: context)
                                    : "atHome".translate(context: context),
                                subtitle: widget.isAtStoreOptionSelected == "1"
                                    ? "atStoreDescription".translate(context: context)
                                    : "atHomeDescription".translate(context: context),
                                leadingIcon: CustomSvgPicture(
                                  svgImage: widget.isAtStoreOptionSelected == "1"
                                      ? "store.svg"
                                      : "home.svg",
                                  color: Theme.of(context).colorScheme.accentColor,
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                            ],
                            if (widget.instruction != null && widget.instruction != "") ...[
                              Text(
                                'instructions'.translate(context: context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                              customOrderSummeryTile(
                                context,
                                title: widget.instruction ?? "",
                                leadingIcon: CustomSvgPicture(
                                  svgImage: 'instrucstion.svg',
                                  color: Theme.of(context).colorScheme.accentColor,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                            ],
                            Text(
                              "saveExtra".translate(context: context),
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.rh(context),
                            ),
                            CustomInkWellContainer(
                              onTap: () {
                                if (providerId == "0" || providerId == null) {
                                  UiUtils.showMessage(
                                    context,
                                    'somethingWentWrong'.translate(context: context),
                                    MessageType.warning,
                                  );
                                  return;
                                }
                                Navigator.pushNamed(
                                  context,
                                  promocodeScreen,
                                  arguments: {
                                    "isFrom": widget.isFrom,
                                    "providerID": providerId,
                                    "isAtStoreOptionSelected": widget.isAtStoreOptionSelected
                                  },
                                ).then((final Object? value) {
                                  final parameter = value as Map;
                                  promoCodeDiscount = double.parse(parameter["discount"]);
                                  promoCodeName = parameter["promoCodeName"];

                                  setState(() {});
                                });
                              },
                              child: customOrderSummeryTile(
                                context,
                                title: "applyCoupon".translate(context: context),
                                subtitle: promoCodeName != ""
                                    ? "$promoCodeName applied"
                                    : "applyCouponAndGetExtraDiscount".translate(context: context),
                                isMultipleText: true,
                                leadingIcon: Icon(
                                  Icons.discount,
                                  color: Theme.of(context).colorScheme.accentColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.rh(context),
                            ),
                            if (context
                                    .read<CartCubit>()
                                    .isPayLaterAllowed(isFrom: widget.isFrom) ==
                                '1') ...[
                              Text(
                                "paymentOptions".translate(context: context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondaryColor,
                                  borderRadius: BorderRadius.circular(borderRadiusOf10),
                                ),
                                //   padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: List.generate(
                                    //if pay later allowed then we will show all payment methods
                                    //else we will remove last method (which is pay later)
                                    context
                                                .read<CartCubit>()
                                                .isPayLaterAllowed(isFrom: widget.isFrom) ==
                                            '1'
                                        ? paymentMethods.length
                                        : paymentMethods.length - 1,
                                    (final int index) => RadioListTile(
                                      title: Text(
                                        paymentMethods[index]["title"]!.translate(context: context),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        (widget.isAtStoreOptionSelected == "1"
                                                ? paymentMethods[index]["atStoreDescription"]!
                                                : paymentMethods[index]["description"]!)
                                            .translate(context: context),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      value: paymentMethods[index]["title"]!,
                                      activeColor: Theme.of(context).colorScheme.accentColor,
                                      groupValue: selectedPaymentMethod,
                                      onChanged: (final Object? selectedValue) {
                                        selectedPaymentMethod = selectedValue.toString();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.rh(context),
                              ),
                            ],
                          ],
                        ),
                      ),
                      BlocBuilder<CartCubit, CartState>(
                        builder: (final BuildContext context, final CartState state) {
                          if (state is CartFetchSuccess) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondaryColor,
                                borderRadius: BorderRadius.circular(borderRadiusOf15),
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: widget.isFrom == "cart"
                                        ? state.cartData.cartDetails!.length
                                        : state.reOrderCartData?.cartDetails!.length,
                                    itemBuilder: (final context, index) {
                                      final cartDetails = widget.isFrom == "cart"
                                          ? state.cartData.cartDetails![index]
                                          : state.reOrderCartData?.cartDetails![index];
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                                            child: chargesTile(
                                              title1: ' ${cartDetails?.serviceDetails!.title}',
                                              title2:
                                                  "${'qty'.translate(context: context)}:${cartDetails!.qty}",
                                              title3:
                                                  (cartDetails.serviceDetails!.discountedPrice !=
                                                              '0'
                                                          ? cartDetails.serviceDetails!.priceWithTax
                                                              .toString()
                                                          : cartDetails.serviceDetails!.priceWithTax
                                                              .toString())
                                                      .priceFormat(),
                                              fontSize: 14,
                                            ),
                                          ),
                                          const CustomDivider()
                                        ],
                                      );
                                    },
                                  ),
                                  chargesTile(
                                    title1: 'subTotal'.translate(context: context),
                                    title2: '',
                                    title3: (widget.isFrom == "cart"
                                            ? state.cartData.subTotal!
                                            : state.reOrderCartData?.subTotal ?? "0")
                                        .priceFormat(),
                                    fontSize: 14,
                                  ),
                                  if (promoCodeDiscount != 0.0)
                                    chargesTile(
                                      title1: "couponDiscount".translate(context: context),
                                      title2: '',
                                      title3: '- ${promoCodeDiscount.toString().priceFormat()}',
                                      fontSize: 14,
                                    ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (widget.isFrom == "cart" &&
                                      state.cartData.visitingCharges != '0' &&
                                      state.cartData.visitingCharges != "" &&
                                      state.cartData.visitingCharges != 'null' &&
                                      widget.isAtStoreOptionSelected == "0")
                                    chargesTile(
                                      title1: 'visitingCharge'.translate(context: context),
                                      title2: '',
                                      title3: '+ ${state.cartData.visitingCharges!.priceFormat()}',
                                      fontSize: 14,
                                    ),
                                  if (widget.isFrom == "reOrder" &&
                                      state.reOrderCartData?.visitingCharges != '0' &&
                                      state.reOrderCartData?.visitingCharges != "" &&
                                      state.reOrderCartData?.visitingCharges != 'null' &&
                                      widget.isAtStoreOptionSelected == "0")
                                    chargesTile(
                                      title1: 'visitingCharge'.translate(context: context),
                                      title2: '',
                                      title3:
                                          '+ ${(state.reOrderCartData?.visitingCharges ?? "0").priceFormat()}',
                                      fontSize: 14,
                                    ),
                                  const CustomDivider(),
                                  chargesTile(
                                    title1: 'totalAmount'.translate(context: context),
                                    title2: '',
                                    title3: (double.parse(widget.isFrom == "cart"
                                                ? state.cartData.overallAmount!
                                                : state.reOrderCartData?.overallAmount ?? "0") -
                                            promoCodeDiscount -
                                            (widget.isAtStoreOptionSelected == "1"
                                                ? double.parse(widget.isFrom == "cart"
                                                    ? state.cartData.visitingCharges ?? "0"
                                                    : state.reOrderCartData?.visitingCharges ?? "0")
                                                : 0))
                                        .toStringAsFixed(2)
                                        .priceFormat(),
                                    fontSize: 18,
                                    isBoldText: true,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    color: Theme.of(context).colorScheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: BlocConsumer<PlaceOrderCubit, PlaceOrderState>(
                      listener: (final BuildContext context, PlaceOrderState state) {
                        if (state is PlaceOrderSuccess) {
                          if (!state.isError) {
                            //
                            placedOrderId = state.orderId;
                            //
                            //we will get cart total amount form cart cubit
                            //and promocode is applied then we will subtract that amount for online pay
                            final double cartTotalAmount = double.parse(context
                                    .read<CartCubit>()
                                    .getTotalCartAmount(
                                        isFrom: widget.isFrom,
                                        isAtStoreBooked: widget.isAtStoreOptionSelected == "1")) -
                                promoCodeDiscount;
                            //
                            if (selectedPaymentMethod == "payOnService") {
                              navigateToOrderConfirmation(isSuccess: true);
                            } else {
                              if (paymentGatewaySetting!.stripeStatus == "enable") {
                                //
                                openStripePaymentGateway(
                                  orderAmount: cartTotalAmount,
                                  placedOrderId: state.orderId,
                                );
                                //
                              } else if (paymentGatewaySetting!.razorpayApiStatus == "enable") {
                                //
                                openRazorPayGateway(
                                  orderAmount: cartTotalAmount,
                                  placedOrderId: state.orderId,
                                  razorpayOrderId: state.razorpayOrderId,
                                );
                                //
                              } else if (paymentGatewaySetting!.paystackStatus == "enable") {
                                //
                                openPaystackPaymentGateway(
                                  orderAmount: cartTotalAmount,
                                  emailId: Hive.box(userDetailBoxKey).get(emailIdKey) ??
                                      "test@gmail.com",
                                  placedOrderId: state.orderId,
                                );
                              } else if (paymentGatewaySetting!.paypalStatus == "enable") {
                                //
                                Navigator.pushNamed(
                                  context,
                                  paypalPaymentScreen,
                                  arguments: {'paymentURL': state.paypalLink},
                                ).then((final Object? value) {
                                  final parameter = value as Map;
                                  if (parameter['paymentStatus'] == 'Completed') {
                                    //
                                    navigateToOrderConfirmation(isSuccess: true);
                                    //
                                  } else if (parameter['paymentStatus'] == 'Failed') {
                                    navigateToOrderConfirmation(isSuccess: false);
                                  }
                                });
                                //
                              } else {
                                UiUtils.showMessage(
                                  context,
                                  "onlinePaymentNotAvailableNow".translate(context: context),
                                  MessageType.warning,
                                );
                              }
                            }
                          } else {
                            UiUtils.showMessage(context, state.message.translate(context: context),
                                MessageType.error);
                          }
                        }
                        if (state is PlaceOrderFailure) {
                          UiUtils.showMessage(context,
                              state.errorMessage.translate(context: context), MessageType.error);
                        }
                      },
                      builder: (context, PlaceOrderState state) {
                        Widget? child;
                        if (state is PlaceOrderInProgress) {
                          child = Center(
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColors,
                            ),
                          );
                        } else if (state is PlaceOrderFailure || state is PlaceOrderSuccess) {
                          child = null;
                        }

                        return ValueListenableBuilder(
                          valueListenable: paymentButtonName,
                          builder: (context, value, _) {
                            return CustomRoundedButton(
                              onTap: () {
                                if (state is PlaceOrderInProgress) {
                                  return;
                                }
                                //
                                var selectedPaymentGateway = "";

                                if (selectedPaymentMethod == "payOnService") {
                                  selectedPaymentGateway = 'cod';
                                } else {
                                  if (paymentGatewaySetting!.stripeStatus == "enable") {
                                    //
                                    selectedPaymentGateway = 'stripe';
                                  } else if (paymentGatewaySetting!.razorpayApiStatus == "enable") {
                                    //
                                    selectedPaymentGateway = 'razorpay';
                                  } else if (paymentGatewaySetting!.paystackStatus == "enable") {
                                    //
                                    selectedPaymentGateway = 'paystack';
                                  } else if (paymentGatewaySetting!.paypalStatus == "enable") {
                                    //
                                    selectedPaymentGateway = 'paypal';
                                  }
                                }
                                //
                                context.read<PlaceOrderCubit>().placeOrder(
                                      status: "awaiting",
                                      orderId: widget.orderId,
                                      selectedAddressID: widget.selectedAddress?.id,
                                      promoCode: promoCodeName,
                                      paymentMethod: selectedPaymentGateway,
                                      orderNote: widget.instruction ?? "",
                                      dateOfService: widget.selectedDate!,
                                      startingTime: widget.selectedTime!,
                                      isAtStoreOptionSelected: widget.isAtStoreOptionSelected,
                                    );
                              },
                              widthPercentage: 0.9,
                              showBorder: false,
                              fontWeight: FontWeight.bold,
                              radius: 10,
                              backgroundColor: Theme.of(context).colorScheme.accentColor,
                              buttonTitle: selectedPaymentMethod == "payOnService"
                                  ? 'bookService'.translate(context: context)
                                  : paymentButtonName.value.translate(context: context),
                              child: child,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget chargesTile({
    required final String title1,
    required final String title2,
    required final String title3,
    required final double fontSize,
    final bool isBoldText = false,
  }) =>
      Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title1,
              style: TextStyle(fontSize: fontSize, fontWeight: isBoldText ? FontWeight.bold : null),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              title2,
              style: TextStyle(fontSize: fontSize),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              title3,
              style: TextStyle(fontWeight: isBoldText ? FontWeight.bold : null, fontSize: fontSize),
              textAlign: TextAlign.end,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )
        ],
      );

  Widget customOrderSummeryTile(
    final context, {
    required final Widget leadingIcon,
    required final String title,
    final String? subtitle,
    final bool? isMultipleText = false,
  }) =>
      Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryColor,
            borderRadius: BorderRadius.circular(borderRadiusOf10),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              leadingIcon,
              SizedBox(
                width: 10.rw(context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMultipleText!) ...[
                    SizedBox(
                      width: 200.rw(context),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      subtitle ?? '',
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ] else ...[
                    SizedBox(
                      width: 200.rw(context),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ]
                ],
              ),
            ],
          ),
        ),
      );
}
