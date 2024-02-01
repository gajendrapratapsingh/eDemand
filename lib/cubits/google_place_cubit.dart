// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:e_demand/app/generalImports.dart';

abstract class GooglePlaceAutocompleteState {}

class GooglePlaceAutocompleteInitial extends GooglePlaceAutocompleteState {}

class GooglePlaceAutocompleteInProgress extends GooglePlaceAutocompleteState {}

class GooglePlaceAutocompleteSuccess extends GooglePlaceAutocompleteState {
  // List<GooglePlaceModel> autocompleteResult;
  PlacesModel autocompleteResult;

  GooglePlaceAutocompleteSuccess(this.autocompleteResult);
}

class GooglePlaceAutocompleteFail extends GooglePlaceAutocompleteState {
  dynamic error;

  GooglePlaceAutocompleteFail(this.error);
}

class GooglePlaceAutocompleteCubit extends Cubit<GooglePlaceAutocompleteState> {
  GooglePlaceAutocompleteCubit() : super(GooglePlaceAutocompleteInitial());
  final GooglePlaceRepository _googlePlaceAutocomplete = GooglePlaceRepository();

  Future<void> searchLocationFromPlacesAPI({required final String text}) async {
    try {
      emit(GooglePlaceAutocompleteInProgress());
      final PlacesModel googlePlaceAutocompleteResponse =
          await _googlePlaceAutocomplete.searchLocationsFromPlaceAPI(text);
      emit(GooglePlaceAutocompleteSuccess(googlePlaceAutocompleteResponse));
    } catch (e) {
      emit(GooglePlaceAutocompleteFail(e));

      rethrow;
    }
  }

  void clearCubit() {
    emit(GooglePlaceAutocompleteSuccess(PlacesModel()));
    Future.delayed(const Duration(microseconds: 300), () {
      emit(GooglePlaceAutocompleteInitial());
    });
  } /*  clearCubit() {
    emit(GooglePlaceAutocompleteSuccess([]));
    Future.delayed(const Duration(microseconds: 300), () {
      emit(GooglePlaceAutocompleteInitial());
    });
  }*/
}
