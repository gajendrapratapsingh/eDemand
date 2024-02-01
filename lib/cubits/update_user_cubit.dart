import 'package:e_demand/app/generalImports.dart';

abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserInProgress extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {

  UpdateUserSuccess(this.updatedDetails);
  final UpdateUserDetails updatedDetails;
}

class UpdateUserFail extends UpdateUserState {

  UpdateUserFail({required this.error});
  final String error;
}

class UpdateUserCubit extends Cubit<UpdateUserState> {
  UpdateUserCubit() : super(UpdateUserInitial());

  final UserRepository userRepository = UserRepository();

  Future<void> updateUserDetails(final UpdateUserDetails details) async {
    try {
      emit(UpdateUserInProgress());
      final Map<String,dynamic> response = await userRepository.updateUserDetails(details);

      final UpdateUserDetails userUpdatedData = UpdateUserDetails.fromMap(response["data"]);

      emit(UpdateUserSuccess(userUpdatedData));

    } catch (e) {
      emit(UpdateUserFail(error: e.toString()));
    }
  }
}
