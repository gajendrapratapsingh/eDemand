//Cubit
import 'package:e_demand/app/generalImports.dart';

class SliderImagesCubit extends Cubit<SliderImagesState> {

  SliderImagesCubit(this.systemRepository) : super(SliderImagesInitial());
  final SystemRepository systemRepository;

  //
  ///This method is used to fetch Slider Images
  Future<void> fetchSliderImages() async {
    emit(SliderImagesFetchInProgress());

    await systemRepository.getSliderImages(false).then((final value) {
      emit(SliderImagesFetchSuccess(
          listOfSliderImages: value['sliderImages'],
          totalSliderImages: value['totalSliderImages'],),);
    }).catchError((final e) {
      emit(SliderImagesFetchInFailure(errorMessage: e.toString()));
    });
  }
}

//State
abstract class SliderImagesState {}

class SliderImagesInitial extends SliderImagesState {}

class SliderImagesFetchInProgress extends SliderImagesState {}

class SliderImagesFetchSuccess extends SliderImagesState {

  SliderImagesFetchSuccess({required this.listOfSliderImages, this.totalSliderImages});
  final List<SliderImages> listOfSliderImages;
  final String? totalSliderImages;
}

class SliderImagesFetchInFailure extends SliderImagesState {

  SliderImagesFetchInFailure({required this.errorMessage});
  final String errorMessage;
}
