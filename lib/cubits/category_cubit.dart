//Cubit
import 'package:e_demand/app/generalImports.dart';

class CategoryCubit extends Cubit<CategoryState> {

  CategoryCubit(this.categoryRepository) : super(CategoryInitial());
  CategoryRepository categoryRepository;

  void getCategory() {
    emit(CategoryFetchInProgress());

    categoryRepository.fetchCategory().then((final value) {
      emit(CategoryFetchSuccess(categoryList: value));
    }).catchError((final e) {
      emit(CategoryFetchFailure(errorMessage: e.toString()));
    });
  }
}

//State
@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryFetchInProgress extends CategoryState {}

class CategoryFetchSuccess extends CategoryState {

  CategoryFetchSuccess({required this.categoryList});
  final List<CategoryModel> categoryList;
}

class CategoryFetchFailure extends CategoryState {

  CategoryFetchFailure({required this.errorMessage});
  final String errorMessage;
}
