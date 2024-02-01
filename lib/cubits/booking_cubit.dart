import 'package:e_demand/app/generalImports.dart';

//State
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingFetchInProgress extends BookingState {}

class BookingFetchSuccess extends BookingState {
  BookingFetchSuccess({
    required this.bookingData,
    required this.isLoadingMoreData,
    required this.loadMoreError,
    required this.totalBooking,
    required this.apiCalledWithStatus,
  });

  final List<Booking> bookingData;
  final int totalBooking;
  final bool isLoadingMoreData;
  final String loadMoreError;
  final String apiCalledWithStatus;

  BookingFetchSuccess copyWith({
    required final int totalBooking,
    required final List<Booking> bookingData,
    required final bool isLoadingMoreData,
    required final String apiCalledWithStatus,
    required final String loadMoreError,
  }) =>
      BookingFetchSuccess(
        apiCalledWithStatus: apiCalledWithStatus,
        isLoadingMoreData: isLoadingMoreData,
        loadMoreError: loadMoreError,
        bookingData: bookingData,
        totalBooking: totalBooking,
      );
}

class BookingFetchFailure extends BookingState {
  BookingFetchFailure({required this.errorMessage});

  final String errorMessage;
}

//cubit
class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this.bookingRepository) : super(BookingInitial());
  final BookingRepository bookingRepository;

  //
  ///This method is used to fetch booking details
  Future<void> fetchBookingDetails({
    required final String status,
  }) async {
    try {

      emit(BookingFetchInProgress());
      //
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.limit: limitOfAPIData,
        Api.offset: "0"
      };
      parameter[Api.status] = status;
      //
      await bookingRepository.fetchBookingDetails(parameter: parameter).then((final value) {
        emit(
          BookingFetchSuccess(
            apiCalledWithStatus: status,
            isLoadingMoreData: false,
            loadMoreError: "",
            bookingData: value['bookingDetails'],
            totalBooking: value['totalBookings'],
          ),
        );
      });
    } catch (e) {
      emit(BookingFetchFailure(errorMessage: e.toString()));
    }
  }

  bool hasMoreBookings() {
    if (state is BookingFetchSuccess) {
      final bool hasMoreData = (state as BookingFetchSuccess).bookingData.length <
          (state as BookingFetchSuccess).totalBooking;

      return hasMoreData;
    }
    return false;
  }

  //
  ///This method is used to fetch booking details
  Future<void> fetchMoreBookingDetails({
    required final String status,
  }) async {
    //
    if (state is BookingFetchSuccess) {
      if ((state as BookingFetchSuccess).isLoadingMoreData) {
        return;
      }
    }
    //
    final Map<String, dynamic> parameter = <String, dynamic>{
      Api.limit: limitOfAPIData,
      Api.offset: (state as BookingFetchSuccess).bookingData.length
    };
    parameter[Api.status] = status;
    //
    final BookingFetchSuccess currentState = state as BookingFetchSuccess;
    emit(
      currentState.copyWith(
        totalBooking: currentState.totalBooking,
        bookingData: currentState.bookingData,
        isLoadingMoreData: true,
        apiCalledWithStatus: status,
        loadMoreError: "",
      ),
    );
    //
    await bookingRepository.fetchBookingDetails(parameter: parameter).then((final value) {
      //
      final List<Booking> oldList = currentState.bookingData;

      oldList.addAll(value['bookingDetails']);

      emit(
        BookingFetchSuccess(
          isLoadingMoreData: false,
          loadMoreError: "",
          bookingData: oldList,
          apiCalledWithStatus: status,
          totalBooking: value['totalBookings'],
        ),
      );
    }).catchError((final e) {
      emit(
        BookingFetchSuccess(
          apiCalledWithStatus: status,
          isLoadingMoreData: false,
          loadMoreError: "",
          bookingData: currentState.bookingData,
          totalBooking: currentState.totalBooking,
        ),
      );
    });
  }

  Future<void> updateBookingStatusLocally(
      {required String bookingId, required String bookingStatus}) async {
    //
    if (state is BookingFetchSuccess) {
      //
      final List<Booking> bookingData = (state as BookingFetchSuccess).bookingData;

      final List<Booking> tempBookingData = [];
      //
      for (var value in bookingData) {
        if (value.id == bookingId) {
          value.status = bookingStatus;
          tempBookingData.add(value);
        } else {
          tempBookingData.add(value);
        }
      }
      //
      bookingData.addAll(tempBookingData);
      //
      final BookingFetchSuccess currentState = state as BookingFetchSuccess;

      emit(currentState.copyWith(
          totalBooking: currentState.totalBooking,
          bookingData: bookingData,
          isLoadingMoreData: currentState.isLoadingMoreData,
          apiCalledWithStatus: currentState.apiCalledWithStatus,
          loadMoreError: currentState.loadMoreError));
    }
  }

  Future<void> updateBookingDataLocally({required Booking latestBookingData}) async {
    //
    if (state is BookingFetchSuccess) {
      //
      final List<Booking> bookingData = (state as BookingFetchSuccess).bookingData;
      //
      for(int i = 0;i< bookingData.length;i++){
        if(bookingData[i].id==latestBookingData.id){
          bookingData[i] = latestBookingData;
        }
      }
      //
      final BookingFetchSuccess currentState = state as BookingFetchSuccess;

      emit(currentState.copyWith(
          totalBooking: currentState.totalBooking,
          bookingData: bookingData,
          isLoadingMoreData: currentState.isLoadingMoreData,
          apiCalledWithStatus: currentState.apiCalledWithStatus,
          loadMoreError: currentState.loadMoreError));
    }
  }
}
