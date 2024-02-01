//Cubit
import 'package:e_demand/app/generalImports.dart';

class ValidatePromocodeCubit extends Cubit<ValidatePromoCodeState> {

  ValidatePromocodeCubit({required this.cartRepository}) : super(ValidatePromoCodeInitial());
  CartRepository cartRepository;

  Future<void> validatePromoCodes(
      {required final String totalAmount,
      required final String promocodeName,
      required final String promoCodeID,}) async {
    emit(ValidatePromoCodeInProgress(promoCodeID: promoCodeID));

    final value = await cartRepository
        .validatePromocode(promocode: promocodeName, totalAmount: totalAmount)
        // ignore: body_might_complete_normally_catch_error
        .catchError((final e) {
      emit(ValidatePromoCodeFailure(errorMessage: e.toString()));
    });
    emit(ValidatePromoCodeSuccess(
        error: value['error'],
        message: value['message'],
        discountAmount: value['discountAmount'] ?? '0',
        totalOrderAmount: value['finalOrderAmount'] ?? totalAmount,
        promoCodeId: promoCodeID,),);
  }
}

//State

abstract class ValidatePromoCodeState {}

class ValidatePromoCodeInitial extends ValidatePromoCodeState {}

class ValidatePromoCodeInProgress extends ValidatePromoCodeState {

  ValidatePromoCodeInProgress({required this.promoCodeID});
  final String promoCodeID;
}

class ValidatePromoCodeSuccess extends ValidatePromoCodeState {

  ValidatePromoCodeSuccess(
      {required this.error,
      required this.message,
      required this.totalOrderAmount,
      required this.discountAmount,
      required this.promoCodeId,});
  final bool error;
  final String message;
  final String totalOrderAmount;
  final String discountAmount;
  final String promoCodeId;
}

class ValidatePromoCodeFailure extends ValidatePromoCodeState {

  ValidatePromoCodeFailure({required this.errorMessage});
  final String errorMessage;
}
