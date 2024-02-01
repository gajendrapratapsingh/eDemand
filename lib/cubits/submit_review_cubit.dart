import 'package:e_demand/app/generalImports.dart';

abstract class SubmitReviewState {}

class SubmitReviewInitial extends SubmitReviewState {}

class SubmitReviewInProgress extends SubmitReviewState {}

class SubmitReviewSuccess extends SubmitReviewState {

  SubmitReviewSuccess({required this.message, required this.error});
  final String message;
  final bool error;
}

class SubmitReviewFailure extends SubmitReviewState {
  SubmitReviewFailure({required this.errorMessage});

  final dynamic errorMessage;
}

class SubmitReviewCubit extends Cubit<SubmitReviewState> {
  SubmitReviewCubit({required this.bookingRepository}) : super(SubmitReviewInitial());
  BookingRepository bookingRepository = BookingRepository();

  Future<void> submitReview({
    required final String serviceId,
    required final String ratingStar,
    required final String reviewComment,
    final List<XFile?>? reviewImages,
  }) async {
    emit(SubmitReviewInProgress());
    await bookingRepository
        .submitReviewToService(
            serviceId: serviceId,
            ratingStar: ratingStar,
            reviewComment: reviewComment,
            reviewImages: reviewImages,)
        .then((final value) async {
      //emit success state
      emit(SubmitReviewSuccess(message: value['message'], error: value['error']));
    }).catchError((final error) {
      emit(SubmitReviewFailure(errorMessage: error.toString()));
    });
  }
}
