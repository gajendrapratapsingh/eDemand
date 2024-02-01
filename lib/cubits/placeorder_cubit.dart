import 'package:e_demand/app/generalImports.dart';

abstract class PlaceOrderState {}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderInProgress extends PlaceOrderState {}

class PlaceOrderSuccess extends PlaceOrderState {
  PlaceOrderSuccess({
    required this.orderId,
    required this.razorpayOrderId,
    required this.isError,
    required this.message,
    required this.paypalLink,
  });

  final bool isError;
  final String message;
  final String orderId;
  final String razorpayOrderId;
  final String paypalLink;
}

class PlaceOrderFailure extends PlaceOrderState {
  PlaceOrderFailure({required this.errorMessage});

  final String errorMessage;
}

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  PlaceOrderCubit({required this.cartRepository}) : super(PlaceOrderInitial());
  CartRepository cartRepository;

  //
  //This method is used to place an order
  Future<void> placeOrder({
    required final String promoCode,
    required final String paymentMethod,
    final String? selectedAddressID,
    final String? orderId,
    required final String isAtStoreOptionSelected,
    required final String status,
    required final String orderNote,
    required final String startingTime,
    required final String dateOfService,
  }) async {
    try {
      emit(PlaceOrderInProgress());

      final orderData = await cartRepository.placeOrder(
        dateOfService: dateOfService,
        orderNote: orderNote,
        paymentMethod: paymentMethod,
        promoCode: promoCode,
        selectedAddressID: selectedAddressID,
        status: status,
        isAtStoreOptionSelected: isAtStoreOptionSelected,
        startingTime: startingTime,
        orderID: orderId,
      );

      String razorpayOrderId = '';
      if (paymentMethod == 'razorpay') {
        razorpayOrderId =
            await cartRepository.createRazorpayOrderId(orderId: orderData['orderId'].toString());
      }
      emit(
        PlaceOrderSuccess(
          razorpayOrderId: razorpayOrderId,
          orderId: orderData['orderId'].toString(),
          isError: orderData['error'],
          message: orderData['message'],
          paypalLink: orderData['paypalLink'],
        ),
      );
    } catch (error) {
      emit(PlaceOrderFailure(errorMessage: error.toString()));
    }
  }
}
