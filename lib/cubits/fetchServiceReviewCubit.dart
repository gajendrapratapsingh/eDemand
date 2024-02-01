import 'package:e_demand/app/generalImports.dart';

//state
abstract class ServiceReviewState {}

class ServiceReviewInitial extends ServiceReviewState {}

class ServiceReviewFetchInProgress extends ServiceReviewState {}

class ServiceReviewFetchSuccess extends ServiceReviewState {
  ServiceReviewFetchSuccess({required this.reviewList, required this.totalReview});

  final List<Reviews> reviewList;
  final String totalReview;
}

class ServiceReviewFetchFailure extends ServiceReviewState {
  ServiceReviewFetchFailure({required this.errorMessage});

  final String errorMessage;
}

class ServiceReviewCubit extends Cubit<ServiceReviewState> {
  final ReviewRepository reviewRepository;
  String? serviceId;
  String? providerId;

  ServiceReviewCubit(
      {required this.reviewRepository, required this.serviceId, required this.providerId,})
      : super(ServiceReviewInitial()) {
    fetchServiceReview(serviceId: serviceId ?? "", providerId: providerId ?? "");
  }

  Future<void> fetchServiceReview(
      {required final String serviceId, required final String providerId,}) async {
    emit(ServiceReviewFetchInProgress());
    await reviewRepository
        .getReviews(isAuthTokenRequired: false, serviceId: serviceId, providerId: providerId)
        .then(
          (final value) => emit(
            ServiceReviewFetchSuccess(
              reviewList: value["Reviews"],
              totalReview: value["totalReviews"],
            ),
          ),
        )
        .catchError((final e) => emit(ServiceReviewFetchFailure(errorMessage: e.toString())));
  }
}
