import 'package:e_demand/app/generalImports.dart';

abstract class ResendOtpState {}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpInProcess extends ResendOtpState {}

class ResendOtpSuccess extends ResendOtpState {}

class ResendOtpFail extends ResendOtpState {

  ResendOtpFail(this.error);
  final dynamic error;
}

class ResendOtpCubit extends Cubit<ResendOtpState> {

  ResendOtpCubit() : super(ResendOtpInitial());
  final AuthenticationRepository authRepo = AuthenticationRepository();

  Future<void> resendOtp(final String phoneNumber, {final VoidCallback? onOtpSent}) async {
    try {
      emit(ResendOtpInProcess());
      await authRepo.verifyPhoneNumber(
        phoneNumber,
        onError: (final err) {
          emit(ResendOtpFail(err));
        },
        onCodeSent: () {
          onOtpSent?.call();
          emit(ResendOtpSuccess());
        },
      );
      // await Future.delayed(const Duration(milliseconds: 400));
    } on FirebaseAuthException catch (error) {
      emit(ResendOtpFail(error));
    }
  }

  void setDefaultOtpState() {
    emit(ResendOtpInitial());
  }
}
