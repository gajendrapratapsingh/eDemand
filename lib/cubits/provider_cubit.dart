import 'package:e_demand/app/generalImports.dart';

abstract class ProviderState {}

class ProviderInitial extends ProviderState {}

class ProviderFetchInProgress extends ProviderState {}

class ProviderFetchSuccess extends ProviderState {
  ProviderFetchSuccess({required this.providerList, required this.totalProviders});

  final List<Providers> providerList;
  final String totalProviders;
}

class ProviderFetchFailure extends ProviderState {
  ProviderFetchFailure({required this.errorMessage});

  final String errorMessage;
}

class ProviderCubit extends Cubit<ProviderState> {
  ProviderCubit(this.providerRepository) : super(ProviderInitial());
  ProviderRepository providerRepository;

  //
  ///This method is used to fetch subCategories and Providers based on CategoryId/SubCategory Id
  Future<void> getProviders(
      {final String? categoryID, final String? subCategoryID, final String? filter}) async {
    try {
      emit(ProviderFetchInProgress());
      final Map<String, dynamic> providersData;

      providersData = await providerRepository.fetchProviderList(
        isAuthTokenRequired: true,
        categoryId: categoryID ?? "",
        subCategoryId: subCategoryID ?? "",
        filter: filter ?? "",
      );

      emit(
        ProviderFetchSuccess(
          providerList: providersData['providerList'],
          totalProviders: providersData['totalProviders'],
        ),
      );
    } catch (error) {
      emit(ProviderFetchFailure(errorMessage: error.toString()));
    }
  }

}
