import 'package:e_demand/app/generalImports.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartFetchInProgress extends CartState {
  final String? reOrderId;

  CartFetchInProgress({this.reOrderId});
}

class CartFetchSuccess extends CartState {
  CartFetchSuccess(
      {this.bookingDetails,
      this.isReorderFrom,
      this.reOrderId,
      required this.isReorderCart,
      this.reOrderCartData,
      required this.cartData});

  final String? reOrderId;
  final String? isReorderFrom;
  final bool isReorderCart;
  final Cart cartData;
  final Cart? reOrderCartData;
  final Booking? bookingDetails;
}

class CartFetchFailure extends CartState {
  CartFetchFailure({this.reOrderBookingId, required this.errorMessage});

  final String errorMessage;
  final String? reOrderBookingId;
}

class CartCubit extends Cubit<CartState> {
  CartCubit(this.cartRepository) : super(CartInitial());
  CartRepository cartRepository;

  //
  ///This method is used to fetch cart details
  Future<void> getCartDetails({
    final String? reOrderId,
    final String? isReorderFrom,
    required final bool isReorderCart,
    final Booking? bookingDetails,
  }) async {
    try {
      emit(CartFetchInProgress(reOrderId: reOrderId));

      final Map<String, dynamic> cartData =
          await cartRepository.getUserCart(useAuthToken: true, reOrderId: reOrderId);
      //

      emit(CartFetchSuccess(
          isReorderFrom: isReorderFrom,
          bookingDetails: bookingDetails,
          reOrderId: reOrderId,
          isReorderCart: isReorderCart,
          cartData: Cart.fromJson(Map.from(cartData["cartData"])),
          reOrderCartData: Cart.fromJson(Map.from(cartData["reOrderCartData"]))));
    } catch (e) {
      emit(CartFetchFailure(reOrderBookingId: reOrderId, errorMessage: e.toString()));
    }
  }

  void updateCartDetails(final Cart cartDetails) {
    try {
      emit(
        CartFetchSuccess(
          reOrderId: "0",
          isReorderCart: false,
          cartData: cartDetails,
        ),
      );
    } catch (_) {}
  }

  String getProviderIDFromCartData() {
    if (state is CartFetchSuccess) {
      final Cart cartData = (state as CartFetchSuccess).cartData;
      return cartData.providerId ?? '0';
    }
    return '0';
  }

  String getTotalCartAmount({required bool isAtStoreBooked, required String isFrom}) {
    if (state is CartFetchSuccess) {
      final Cart cartData = isFrom == "cart"
          ? (state as CartFetchSuccess).cartData
          : (state as CartFetchSuccess).reOrderCartData!;
      //
      final double visitingCharge =
          isAtStoreBooked ? double.parse(cartData.visitingCharges ?? "0") : 0;

      return (double.parse(cartData.overallAmount ?? '0') - visitingCharge).toString();
    }
    return '0';
  }

  String isPayLaterAllowed({required String isFrom}) {
    if (state is CartFetchSuccess) {
      final Cart cartData = isFrom == "cart"
          ? (state as CartFetchSuccess).cartData
          : (state as CartFetchSuccess).reOrderCartData!;

      return cartData.isPayLaterAllowed ?? "0";
    }
    return "0";
  }

  String getServiceCartQuantity({required final String serviceId}) {
    String quantityInCart = "0";
    if (state is CartFetchSuccess) {
      (state as CartFetchSuccess).cartData.cartDetails?.forEach((final element) {
        if (element.serviceId == serviceId) {
          quantityInCart = element.qty.toString();
          return;
        }
      });
    }
    return quantityInCart;
  }

  void clearCartCubit() {
    emit(CartFetchSuccess(cartData: Cart(), isReorderCart: false, reOrderCartData: Cart()));
  }

  bool checkAtStoreProviderAvailable({required String isFrom}) {
    if (state is CartFetchSuccess) {
      return isFrom == "cart"
          ? (state as CartFetchSuccess).cartData.isAtStoreAvailable == "1"
          : (state as CartFetchSuccess).reOrderCartData!.isAtStoreAvailable == "1";
    }
    return false;
  }

  bool checkAtDoorstepProviderAvailable({required String isFrom}) {
    if (state is CartFetchSuccess) {
      return isFrom == "cart"
          ? (state as CartFetchSuccess).cartData.isAtDoorstepAvailable == "1"
          : (state as CartFetchSuccess).reOrderCartData!.isAtDoorstepAvailable == "1";
    }
    return false;
  }
}
