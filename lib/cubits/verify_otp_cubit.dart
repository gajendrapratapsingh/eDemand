// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';

abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpInProcess extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {

  VerifyOtpSuccess(this.signinCredential);
  UserCredential signinCredential;
}

class VerifyOtpFail extends VerifyOtpState {

  VerifyOtpFail(this.error);
  final dynamic error;
}

class VerifyOtpCubit extends Cubit<VerifyOtpState> {

  VerifyOtpCubit() : super(VerifyOtpInitial());
  final AuthenticationRepository authRepo = AuthenticationRepository();

  Future<void> verifyOtp(final String otp) async {
    try {
      emit(VerifyOtpInProcess());
      await authRepo.verifyOtp(
          code: otp,
          onVerificationSuccess: (final UserCredential signinCredential) {
            emit(VerifyOtpSuccess(signinCredential));
          },);
    } on FirebaseAuthException catch (error) {
      emit(VerifyOtpFail(error));
    }
  }

  void setInitialState() {
    if (state is VerifyOtpFail) {
      emit(VerifyOtpInitial());
    }
    if (state is VerifyOtpSuccess) {
      emit(VerifyOtpInitial());
    }
  }
}
