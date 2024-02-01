//Cubit
import 'package:e_demand/app/generalImports.dart';

class ValidateCustomTimeCubit extends Cubit<ValidateCustomTimeState> {
  ValidateCustomTimeCubit({required this.cartRepository}) : super(ValidateCustomTimeInitial());
  CartRepository cartRepository;

  void validateCustomTime({
    required final String providerId,
    final String? orderId,
    required final String selectedDate,
    required final String selectedTime,
  }) {
    emit(ValidateCustomTimeInProgress());

    cartRepository
        .validateCustomTime(
      providerId: providerId,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      orderId: orderId
    )
        .then((final value) {
      emit(
        ValidateCustomTimeSuccess(
          error: value['error'],
          message: value['message'],
        ),
      );
    }).catchError((final e) {
      emit(ValidateCustomTimeFailure(errorMessage: e.toString()));
    });
  }
}

//State

abstract class ValidateCustomTimeState {}

class ValidateCustomTimeInitial extends ValidateCustomTimeState {}

class ValidateCustomTimeInProgress extends ValidateCustomTimeState {
  ValidateCustomTimeInProgress();
}

class ValidateCustomTimeSuccess extends ValidateCustomTimeState {
  ValidateCustomTimeSuccess({
    required this.error,
    required this.message,
  });

  final bool error;
  final String message;
}

class ValidateCustomTimeFailure extends ValidateCustomTimeState {
  ValidateCustomTimeFailure({required this.errorMessage});

  final String errorMessage;
}
