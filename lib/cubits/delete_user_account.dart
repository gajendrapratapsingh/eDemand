//Cubit
import 'package:e_demand/app/generalImports.dart';

class DeleteUserAccountCubit extends Cubit<DeleteUserAccountState> {

  DeleteUserAccountCubit(this.authenticationRepository) : super(DeleteUserAccountInitial());
  AuthenticationRepository authenticationRepository;

  void deleteUserAccount() {
    emit(DeleteUserAccountInProgress());

    authenticationRepository.deleteUserAccount().then((final value) {
      if (value['error']) {
        emit(DeleteUserAccountFailure(
          errorMessage: value['message'],
        ),);
        return;
      }
      emit(DeleteUserAccountSuccess(message: value['message'], error: value['error']));
    }).catchError((final e) {
      emit(DeleteUserAccountFailure(
        errorMessage: e.toString(),
      ),);
    });
  }
}

//State
@immutable
abstract class DeleteUserAccountState {}

class DeleteUserAccountInitial extends DeleteUserAccountState {}

class DeleteUserAccountInProgress extends DeleteUserAccountState {}

class DeleteUserAccountSuccess extends DeleteUserAccountState {

  DeleteUserAccountSuccess({required this.error, required this.message});
  final String message;
  final bool error;
}

class DeleteUserAccountFailure extends DeleteUserAccountState {

  DeleteUserAccountFailure({required this.errorMessage});
  final String errorMessage;
}
