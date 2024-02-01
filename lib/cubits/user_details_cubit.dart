import 'package:e_demand/app/generalImports.dart';

abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetails extends UserDetailsState {

  UserDetails(this.userDetailsModel);
  final UserDetailsModel userDetailsModel;
}

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());

  void setUserDetails(final UserDetailsModel details) {
    emit(UserDetails(details));
  }

  void loadUserDetails() {
     final Map detailsMap = Hive.box(userDetailBoxKey).toMap();

      final UserDetailsModel userDetailsModel = UserDetailsModel.fromMap(Map.from(detailsMap));
    emit(UserDetails(userDetailsModel));
  }

  void changeUserDetails(final UserDetailsModel details) {
    if (state is UserDetails) {

      final UserDetailsModel oldDetails = (state as UserDetails).userDetailsModel;

      final UserDetailsModel newDetails = oldDetails.copyWith(
          email: details.email,
          username: details.username,
          image: details.image,
          phone: details.phone,
          latitude: details.latitude,
          longitude: details.longitude,);
      emit(UserDetails(newDetails));
    }
  }

  void clearCubit() {
    emit(UserDetails(UserDetailsModel.fromMap({})));
  }

  UserDetailsModel getUserDetails() {
    if (state is UserDetails) {
      return (state as UserDetails).userDetailsModel;
    }
    return UserDetailsModel.fromMap({});
  }
}
