//Cubit
import 'package:e_demand/app/generalImports.dart';

class VerifyPhoneNumberFromAPICubit extends Cubit<VerifyPhoneNumberFromAPIState> {

  VerifyPhoneNumberFromAPICubit({required this.authenticationRepository})
      : super(VerifyPhoneNumberFromAPIInitial());
  AuthenticationRepository authenticationRepository;

  Future<void> verifyPhoneNumberFromAPI({required final String mobileNumber, required final String countryCode}) async {
    emit(VerifyPhoneNumberFromAPIInProgress());

    try {
      final Map<String, dynamic> value = await authenticationRepository.verifyUserMobileNumberFromAPI(
          mobileNumber: mobileNumber, countryCode: countryCode,);

      //if error is true means number already exists,
      //so we will login the user

      if (value['error']) {
        //
        final latitude = Hive.box(userDetailBoxKey).get(latitudeKey) ?? "0.0";
        final longitude = Hive.box(userDetailBoxKey).get(longitudeKey) ?? "0.0";
        //
        await AuthenticationRepository.loginUser(
            countryCode: countryCode,
            mobileNumber: mobileNumber,
            latitude: latitude.toString(),
            longitude: longitude.toString(),);
        //
        emit(VerifyPhoneNumberFromAPISuccess(
            navigateToScreen: "homeScreen", statusCode: value["status_code"],),);
      } else {
        emit(VerifyPhoneNumberFromAPISuccess(
            navigateToScreen: "editProfile", statusCode: value["status_code"],),);
      }
    } catch (e) {
      emit(VerifyPhoneNumberFromAPIFailure(errorMessage: e.toString()));
    }
  }
}

//State

abstract class VerifyPhoneNumberFromAPIState {}

class VerifyPhoneNumberFromAPIInitial extends VerifyPhoneNumberFromAPIState {}

class VerifyPhoneNumberFromAPIInProgress extends VerifyPhoneNumberFromAPIState {
  VerifyPhoneNumberFromAPIInProgress();
}

class VerifyPhoneNumberFromAPISuccess extends VerifyPhoneNumberFromAPIState {

  VerifyPhoneNumberFromAPISuccess({
    required this.statusCode,
    required this.navigateToScreen,
  });
  //if error is true then mobile number is already registered
  final String navigateToScreen;
  final String statusCode;
}

class VerifyPhoneNumberFromAPIFailure extends VerifyPhoneNumberFromAPIState {

  VerifyPhoneNumberFromAPIFailure({required this.errorMessage});
  final String errorMessage;
}
