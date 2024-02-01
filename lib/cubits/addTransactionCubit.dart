import 'package:e_demand/app/generalImports.dart';


//State
abstract class AddTransactionState {}

class AddTransactionInitial extends AddTransactionState {}

class AddTransactionInProgress extends AddTransactionState {}

class AddTransactionSuccess extends AddTransactionState {

  AddTransactionSuccess({
    required this.message,
    required this.error,
  });
  final String message;
  final bool error;
}

class AddTransactionFailure extends AddTransactionState {

  AddTransactionFailure({required this.errorMessage});
  final String errorMessage;
}

//cubit
class AddTransactionCubit extends Cubit<AddTransactionState> {

  AddTransactionCubit({required this.bookingRepository}) : super(AddTransactionInitial());
  final BookingRepository bookingRepository;

  //
  ///This method is used to fetch booking details
  Future<void> addTransaction({required final String status, required final String orderID}) async {
    try {
      emit(AddTransactionInProgress());
      //
      final Map<String, dynamic> parameter = <String, dynamic>{Api.status: status, Api.orderId: orderID};
      //
      await bookingRepository.addOnlinePaymentTransaction(parameter: parameter).then((final value) {
        emit(AddTransactionSuccess(
          message: value['message'],
          error: value['error'],
        ),);
      });
    } catch (e) {
      emit(AddTransactionFailure(errorMessage: e.toString()));
    }
  }
}
