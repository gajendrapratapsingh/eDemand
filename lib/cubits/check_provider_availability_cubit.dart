//State
import 'package:e_demand/app/generalImports.dart';

@immutable
abstract class CheckProviderAvailabilityState {}

class CheckProviderAvailability extends CheckProviderAvailabilityState {}

class CheckProviderAvailabilityFetchInProgress extends CheckProviderAvailabilityState {}

class CheckProviderAvailabilityFetchSuccess extends CheckProviderAvailabilityState {
  CheckProviderAvailabilityFetchSuccess({
    required this.error,
    required this.message,
    required this.longitude,
    required this.latitude,
  });

  final bool error;
  final String message;
  final String latitude;
  final String longitude;
}

class CheckProviderAvailabilityFetchFailure extends CheckProviderAvailabilityState {
  CheckProviderAvailabilityFetchFailure({required this.errorMessage});

  final String errorMessage;
}

//Cubit
class CheckProviderAvailabilityCubit extends Cubit<CheckProviderAvailabilityState> {
  CheckProviderAvailabilityCubit({required this.providerRepository})
      : super(CheckProviderAvailability());
  final ProviderRepository providerRepository;

  void checkProviderAvailability({
    required final bool isAuthTokenRequired,
    required final String checkingAtCheckOut,
    required final String latitude,
    required final String longitude,
    final String? orderId,
  }) {
    emit(CheckProviderAvailabilityFetchInProgress());

    providerRepository
        .checkProviderAvailability(
      isAuthTokenRequired: isAuthTokenRequired,
      longitude: longitude,
      latitude: latitude,
      orderId: orderId,
      checkingAtCheckOut: checkingAtCheckOut,
    )
        .then((final value) {
      emit(
        CheckProviderAvailabilityFetchSuccess(
          error: value['error'],
          message: value['message'],
          longitude: longitude,
          latitude: latitude,
        ),
      );
    }).catchError((final e) {
      emit(CheckProviderAvailabilityFetchFailure(errorMessage: e.toString()));
    });
  }
}
