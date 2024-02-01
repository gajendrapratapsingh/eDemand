import 'package:e_demand/app/generalImports.dart';

@immutable
abstract class RemoveServiceFromCartState {}

class RemoveServiceFromCartInitial extends RemoveServiceFromCartState {}

class RemoveServiceFromCartInProgress extends RemoveServiceFromCartState {}

class RemoveServiceFromCartSuccess extends RemoveServiceFromCartState {
  RemoveServiceFromCartSuccess(
      {required this.error, required this.cartDetails, required this.successMessage});

  final String successMessage;
  final Cart? cartDetails;
  final bool error;
}

class RemoveServiceFromCartFailure extends RemoveServiceFromCartState {
  RemoveServiceFromCartFailure({required this.errorMessage});

  final String errorMessage;
}

class RemoveServiceFromCartCubit extends Cubit<RemoveServiceFromCartState> {
  RemoveServiceFromCartCubit(this.cartRepository) : super(RemoveServiceFromCartInitial());
  CartRepository cartRepository;

  Future<void> removeServiceFromCart({required final int serviceId}) async {
    try {
      emit(RemoveServiceFromCartInProgress());

      await cartRepository
          .removeServiceFromCart(useAuthToken: true, serviceId: serviceId)
          .then((final value) {
        emit(
          RemoveServiceFromCartSuccess(
            error: value["error"],
            successMessage: value['message'],
            cartDetails: value['cartData'],
          ),
        );
      }).catchError((final onError) {
        emit(RemoveServiceFromCartFailure(errorMessage: onError.toString()));
      });
    } catch (e) {
      emit(RemoveServiceFromCartFailure(errorMessage: e.toString()));
    }
  }
}
