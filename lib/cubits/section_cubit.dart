import 'package:e_demand/app/generalImports.dart';

class SectionCubit extends Cubit<SectionState> {

  SectionCubit(this.sectionRepository) : super(SectionInitial());
  final SectionRepository sectionRepository;

  void getSectionList() {
    emit(SectionFetchInProgress());
    sectionRepository.fetchSectionList(isAuthTokenRequired: true).then((final value) {
      emit(SectionFetchSuccess(sectionList: value['sectionList']));
    }).catchError((final error) {
      emit(SectionFetchFailure(error.toString()));
    });
  }
}

abstract class SectionState {}

class SectionInitial extends SectionState {}

class SectionFetchInProgress extends SectionState {}

class SectionFetchSuccess extends SectionState {

  SectionFetchSuccess({required this.sectionList});
  final List<Sections> sectionList;
}

class SectionFetchFailure extends SectionState {

  SectionFetchFailure(this.errorMessage);
  final String errorMessage;
}
