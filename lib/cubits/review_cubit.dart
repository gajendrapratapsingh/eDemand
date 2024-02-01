import 'package:e_demand/app/generalImports.dart';

//state
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewFetchInProgress extends ReviewState {}

class ReviewFetchSuccess extends ReviewState {
  ReviewFetchSuccess({required this.reviewList, required this.totalReview});

  final List<Reviews> reviewList;
  final String totalReview;
}

class ReviewFetchFailure extends ReviewState {
  ReviewFetchFailure({required this.errorMessage});

  final String errorMessage;
}

//cubit
class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(this.reviewRepository) : super(ReviewInitial());
  final ReviewRepository reviewRepository;

  Future<void> fetchReview({final String? providerId}) async {
    try {
      emit(ReviewFetchInProgress());
      //
      final Map<String, dynamic> reviewsData =
          await reviewRepository.getReviews(isAuthTokenRequired: false, providerId: providerId);
      //
      emit(
        ReviewFetchSuccess(
          reviewList: reviewsData["Reviews"],
          totalReview: reviewsData["totalReviews"],
        ),
      );
    } catch (e) {
      emit(ReviewFetchFailure(errorMessage: e.toString()));
    }
  }
}
