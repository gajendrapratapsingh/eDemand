//Cubit
import 'package:e_demand/app/generalImports.dart';

class FetchTimeSlotCubit extends Cubit<FetchTimeSlotState> {

  FetchTimeSlotCubit(this.categoryRepository) : super(FetchTimeSlotInitial());
  CategoryRepository categoryRepository;
}

//State
abstract class FetchTimeSlotState {}

class FetchTimeSlotInitial extends FetchTimeSlotState {}

class FetchTimeSlotInProgress extends FetchTimeSlotState {}

class FetchTimeSlotSuccess extends FetchTimeSlotState {

  FetchTimeSlotSuccess({required this.categoryList});
  final List<Category> categoryList;
}

class FetchTimeSlotFailure extends FetchTimeSlotState {

  FetchTimeSlotFailure({required this.errorMessage});
  final String errorMessage;
}
