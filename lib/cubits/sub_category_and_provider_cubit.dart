import 'package:e_demand/app/generalImports.dart';

abstract class SubCategoryAndProviderState {}

class SubCategoryAndProviderInitial extends SubCategoryAndProviderState {}

class SubCategoryAndProviderFetchInProgress extends SubCategoryAndProviderState {}

class FilteredProviderFetchInProgress extends SubCategoryAndProviderState {}

class SubCategoryAndProviderFetchSuccess extends SubCategoryAndProviderState {
  SubCategoryAndProviderFetchSuccess({
    required this.subCategoryList,
    required this.providerList,
    required this.totalProviders,
  });

  final List<SubCategory> subCategoryList;
  final List<Providers> providerList;
  final String totalProviders;
}

class SubCategoryAndProviderFetchFailure extends SubCategoryAndProviderState {
  SubCategoryAndProviderFetchFailure({required this.errorMessage});

  final String errorMessage;
}

/* CUBIT */
class SubCategoryAndProviderCubit extends Cubit<SubCategoryAndProviderState> {
  SubCategoryAndProviderCubit({
    required this.subCategoryRepository,
    required this.providerRepository,
  }) : super(SubCategoryAndProviderInitial());
  SubCategoryRepository subCategoryRepository;
  ProviderRepository providerRepository;

  //
  ///This method is used to fetch subCategories and Providers based on CategoryId/SubCategory Id
  Future<void> getSubCategoriesAndProviderList({
    final String? categoryID,
    final String? subCategoryID,
    final String? providerSortBy,
  }) async {
    try {
      emit(SubCategoryAndProviderFetchInProgress());

      final subCategoryList = await subCategoryRepository.fetchSubCategory(
        categoryID: subCategoryID ?? categoryID ?? '',
        isAuthTokenRequired: false,
      );
      //
      final providersData = await providerRepository.fetchProviderList(
        isAuthTokenRequired: true,
        categoryId: categoryID ?? "",
        subCategoryId: subCategoryID ?? "",
        filter: providerSortBy ?? "",
      );
      if (isClosed) {
        return;
      }
      emit(
        SubCategoryAndProviderFetchSuccess(
          subCategoryList: subCategoryList['subCategoryList'],
          providerList: providersData['providerList'],
          totalProviders: providersData['totalProviders'],
        ),
      );
    } catch (error, st) {
      if (isClosed) return;
      emit(SubCategoryAndProviderFetchFailure(errorMessage: error.toString()));
    }
  }

  List<SubCategory> getSubCategoryList() {
    List<SubCategory> subCategories = <SubCategory>[];
    if (state is SubCategoryAndProviderFetchSuccess) {
      subCategories = (state as SubCategoryAndProviderFetchSuccess).subCategoryList;
    }
    return subCategories;
  }

  void emitSuccessState(
      {required final List<Providers> providerList, required final String totalProviders}) {
    if (state is SubCategoryAndProviderFetchSuccess) {
      final SubCategoryAndProviderFetchSuccess successState =
          state as SubCategoryAndProviderFetchSuccess;

      emit(
        SubCategoryAndProviderFetchSuccess(
          subCategoryList: successState.subCategoryList,
          providerList: providerList,
          totalProviders: totalProviders,
        ),
      );
    }
  }
}
