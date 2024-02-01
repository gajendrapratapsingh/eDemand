import 'package:e_demand/app/generalImports.dart';

abstract class ChangeBookingStatusState {}

class UpdateBookingStatusInitial extends ChangeBookingStatusState {}

class ChangeBookingStatusInProgress extends ChangeBookingStatusState {
  final String pressedButtonName;
  final String bookingId;

  ChangeBookingStatusInProgress({required this.bookingId, required this.pressedButtonName});
}

class ChangeBookingStatusSuccess extends ChangeBookingStatusState {
  ChangeBookingStatusSuccess({
    required this.error,
    required this.message,
    required this.bookingData,
  });

  final String message;
  final bool error;
  final Booking bookingData;
}

class ChangeBookingStatusFailure extends ChangeBookingStatusState {
  ChangeBookingStatusFailure({required this.errorMessage});

  final dynamic errorMessage;
}

class ChangeBookingStatusCubit extends Cubit<ChangeBookingStatusState> {
  ChangeBookingStatusCubit({required this.bookingRepository}) : super(UpdateBookingStatusInitial());
  BookingRepository bookingRepository = BookingRepository();

  void changeBookingStatus(
      {required final String bookingStatus,
      required final String bookingId,
      required final String pressedButtonName,
      String? selectedDate,
      String? selectedTime}) {
    //
    emit(ChangeBookingStatusInProgress(pressedButtonName: pressedButtonName, bookingId: bookingId));
    //
    bookingRepository
        .changeBookingStatus(
            bookingId: bookingId,
            bookingStatus: bookingStatus,
            selectedDate: selectedDate,
            selectedTime: selectedTime)
        .then((final value) {
      emit(ChangeBookingStatusSuccess(
          bookingData: Booking.fromJson(Map.from(value['bookingData'] ?? {})),
          error: value['error'],
          message: value['message']));
    }).catchError((final error) {
      emit(ChangeBookingStatusFailure(errorMessage: error.toString()));
    });
  }
}
