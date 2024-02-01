import 'package:e_demand/app/generalImports.dart';

@immutable
abstract class AddServiceIntoCartState {}

class AddServiceIntoCartInitial extends AddServiceIntoCartState {}

class AddServiceIntoCartInProgress extends AddServiceIntoCartState {}

class AddServiceIntoCartSuccess extends AddServiceIntoCartState {
  AddServiceIntoCartSuccess(
      {required this.cartDetails, required this.successMessage, required this.error});

  final String successMessage;
  final Cart cartDetails;
  final bool error;
}

class AddServiceIntoCartFailure extends AddServiceIntoCartState {
  AddServiceIntoCartFailure({required this.errorMessage});

  final String errorMessage;
}

class AddServiceIntoCartCubit extends Cubit<AddServiceIntoCartState> {
  AddServiceIntoCartCubit(this.cartRepository) : super(AddServiceIntoCartInitial());
  CartRepository cartRepository;

  Future<void> addServiceIntoCart(
      {required final int serviceId, required final int quantity}) async {
    try {
      emit(AddServiceIntoCartInProgress());

      await cartRepository
          .addServiceIntoCart(useAuthToken: true, serviceId: serviceId, quantity: quantity)
          .then((final value) {
        emit(
          AddServiceIntoCartSuccess(
            error: value["error"],
            successMessage: value['message'],
            cartDetails: value['cartData'],
          ),
        );
      }).catchError((final onError) {
        emit(AddServiceIntoCartFailure(errorMessage: onError.toString()));
      });
    } catch (e) {
      emit(AddServiceIntoCartFailure(errorMessage: e.toString()));
    }
  }
}
