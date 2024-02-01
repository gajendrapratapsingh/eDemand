import 'package:e_demand/app/generalImports.dart';

abstract class FetchUserPaymentDetailsState {}

class FetchUserPaymentDetailsInitial extends FetchUserPaymentDetailsState {}

class FetchUserPaymentDetailsInProgress extends FetchUserPaymentDetailsState {}

class FetchUserPaymentDetailsSuccess extends FetchUserPaymentDetailsState {
  final List<Payment> paymentDetails;
  final int totalPaymentCount;
  final bool isLoadingMorePayments;

  FetchUserPaymentDetailsSuccess(
      {required this.isLoadingMorePayments,
      required this.paymentDetails,
      required this.totalPaymentCount});

  FetchUserPaymentDetailsSuccess copyWith({
    final List<Payment>? paymentDetails,
    final int? totalPaymentCount,
    final bool? isLoadingMorePayments,
  }) =>
      FetchUserPaymentDetailsSuccess(
        isLoadingMorePayments: isLoadingMorePayments ?? this.isLoadingMorePayments,
        totalPaymentCount: totalPaymentCount ?? this.totalPaymentCount,
        paymentDetails: paymentDetails ?? this.paymentDetails,
      );
}

class FetchUserPaymentDetailsFailure extends FetchUserPaymentDetailsState {
  final String errorMessage;

  FetchUserPaymentDetailsFailure(this.errorMessage);
}

class FetchUserPaymentDetailsCubit extends Cubit<FetchUserPaymentDetailsState> {
  FetchUserPaymentDetailsCubit(this.systemRepository) : super(FetchUserPaymentDetailsInitial());
  final SystemRepository systemRepository;

  Future<void> fetchUserPaymentDetails() async {
    //
    try {
      emit(FetchUserPaymentDetailsInProgress());

      final Map<String, dynamic> parameter = {Api.limit: limitOfAPIData, Api.offset: 0};
      //
      final paymentData = await systemRepository.getUserPaymentDetails(parameter: parameter);
      //
      emit(
        FetchUserPaymentDetailsSuccess(
            paymentDetails: paymentData['paymentDetails'],
            totalPaymentCount: paymentData['total'],
            isLoadingMorePayments: false),
      );
    } catch (e) {
      emit(FetchUserPaymentDetailsFailure(e.toString()));
    }
  }

  Future<void> fetchUsersMorePaymentDetails() async {
    try {
      //
      final FetchUserPaymentDetailsSuccess currentState = state as FetchUserPaymentDetailsSuccess;
      final List<Payment> paymentOldData = currentState.paymentDetails;
      //
      if (currentState.isLoadingMorePayments) {
        return;
      }
      //
      emit(currentState.copyWith(isLoadingMorePayments: true));
      //
      final Map<String, dynamic> parameter = {
        Api.limit: limitOfAPIData,
        Api.offset: paymentOldData.length
      };
      //
      final paymentNewData = await systemRepository.getUserPaymentDetails(parameter: parameter);
      //
      paymentOldData.addAll(paymentNewData["paymentDetails"]);
      //
      emit(
        currentState.copyWith(
          paymentDetails: paymentOldData,
          isLoadingMorePayments: false,
        ),
      );
    } catch (error) {
      emit(FetchUserPaymentDetailsFailure(error.toString()));
    }
  }

  bool hasMoreTransactions() {
    if (state is FetchUserPaymentDetailsSuccess) {
      return (state as FetchUserPaymentDetailsSuccess).paymentDetails.length <
          (state as FetchUserPaymentDetailsSuccess).totalPaymentCount;
    }
    return false;
  }
}
