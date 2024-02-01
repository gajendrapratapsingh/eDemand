import 'package:e_demand/app/generalImports.dart';
import 'package:intl/intl.dart';

@immutable
abstract class TimeSlotState {}

class TimeSlotInitial extends TimeSlotState {}

class TimeSlotFetchInProgress extends TimeSlotState {}

class TimeSlotFetchSuccess extends TimeSlotState {

  TimeSlotFetchSuccess({required this.isError, required this.message, required this.slotsData});
  final List<AllSlots> slotsData;
  final bool isError;
  final String message;
}

class TimeSlotFetchFailure extends TimeSlotState {

  TimeSlotFetchFailure({required this.errorMessage});
  final String errorMessage;
}

class TimeSlotCubit extends Cubit<TimeSlotState> {

  TimeSlotCubit(this.cartRepository) : super(TimeSlotInitial());
  CartRepository cartRepository;

  //
  //This method is used to fetch timeslot details
  Future<void> getTimeslotDetails({required final int providerID, required final DateTime selectedDate}) async {
    try {
      emit(TimeSlotFetchInProgress());

      await cartRepository
          .fetchTimeSlots(
        providerId: providerID,
        selectedDate: DateFormat("yyyy-MM-dd").format(selectedDate),
        useAuthToken: true,
      )
          .then((final value) {
        //if instance of cubit is disposed then we will return
        if (isClosed) {
          return;
        }
        emit(TimeSlotFetchSuccess(
            message: value['message'],
            isError: value['error'],
            slotsData: value['slots'] as List<AllSlots>,),);
      }).catchError((final onError) {
        if (isClosed) {
          return;
        }

        emit(TimeSlotFetchFailure(errorMessage: onError.toString()));
      });
    } catch (e) {
      if (isClosed) {
        return;
      }
      emit(TimeSlotFetchFailure(errorMessage: e.toString()));
    }
  }
}
