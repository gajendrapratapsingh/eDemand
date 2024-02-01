//Cubit
import 'package:e_demand/app/generalImports.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {

  HomeScreenCubit(this.homeScreenRepository) : super(HomeScreenInitial());
  final HomeScreenRepository homeScreenRepository;

  //
  ///This method is used to fetch Home screen data
  Future<void> fetchHomeScreenData() async {
    try {
      emit(HomeScreenDataFetchInProgress());

      await homeScreenRepository
          .fetchHomeScreenData(
              latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
              longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString(),)
          .then((final value) {
        emit(HomeScreenDataFetchSuccess(homeScreenData: value));
      });
    } catch (e) {
      emit(HomeScreenDataFetchFailure(errorMessage: e.toString()));
    }
  }
}

//State
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenDataFetchInProgress extends HomeScreenState {}

class HomeScreenDataFetchSuccess extends HomeScreenState {

  HomeScreenDataFetchSuccess({required this.homeScreenData});
  final HomeScreenModel homeScreenData;
}

class HomeScreenDataFetchFailure extends HomeScreenState {

  HomeScreenDataFetchFailure({required this.errorMessage});
  final String errorMessage;
}
