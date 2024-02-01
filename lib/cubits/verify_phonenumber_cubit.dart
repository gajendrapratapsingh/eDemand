import 'package:e_demand/app/generalImports.dart';

abstract class VerifyPhoneNumberState {}

class VerifyPhoneNumberInitial extends VerifyPhoneNumberState {}

class PhoneNumberVerificationInProgress extends VerifyPhoneNumberState {}

class SendVerificationCodeInProgress extends VerifyPhoneNumberState {}

class PhoneNumberVerificationSuccess extends VerifyPhoneNumberState {}

class PhoneNumberVerificationFailure extends VerifyPhoneNumberState {

  PhoneNumberVerificationFailure(this.error);
  final dynamic error;
}

class VerifyPhoneNumberCubit extends Cubit<VerifyPhoneNumberState> {

  VerifyPhoneNumberCubit() : super(VerifyPhoneNumberInitial());
  final AuthenticationRepository authRepo = AuthenticationRepository();

  Future<void> verifyPhoneNumber(final String phoneNumber, {final VoidCallback? onCodeSent}) async {
    try {
      emit(PhoneNumberVerificationInProgress());
      await authRepo.verifyPhoneNumber(phoneNumber, onError: (final error) {
        emit(PhoneNumberVerificationFailure(error));
      }, onCodeSent: () {
        emit(SendVerificationCodeInProgress());
      },);
      // await Future.delayed(const Duration(milliseconds: 400));
    } on FirebaseAuthException catch (error) {
      emit(PhoneNumberVerificationFailure(error));
    }
  }

/*  void phoneNumberVerified() {
    if (state is SendVerificationCodeInProgress) {
      emit(PhoneNumberVerificationSuccess());
    }
  }*/

  void setInitialState() {
    if (state is SendVerificationCodeInProgress || state is PhoneNumberVerificationSuccess) {
      emit(VerifyPhoneNumberInitial());
    }
  }
}
