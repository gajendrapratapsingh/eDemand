import 'package:e_demand/app/generalImports.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {}

class UnAuthenticatedState extends AuthenticationState {}

class AuthenticationCubit extends Cubit<AuthenticationState> {

  AuthenticationCubit() : super(AuthenticationInitial()) {
    checkStatus();
  }
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();

  void checkStatus() {
     final result = Hive.box(authStatusBoxKey).get(isAuthenticated);

    if (result == null || result == false) {
      emit(UnAuthenticatedState());
    } else {
      emit(AuthenticatedState());
    }
  }
}
