import 'package:e_demand/app/generalImports.dart';

//state
abstract class ProviderDetailsAndServiceState {}

class ProviderDetailsAndServiceInitial extends ProviderDetailsAndServiceState {}

class ProviderDetailsAndServiceFetchInProgress extends ProviderDetailsAndServiceState {}

class MoreServiceFetchInProgress extends ProviderDetailsAndServiceState {}

class ProviderDetailsAndServiceFetchSuccess extends ProviderDetailsAndServiceState {
  ProviderDetailsAndServiceFetchSuccess({
    required this.providerDetails,
    required this.serviceList,
    required this.totalServices,
    required this.isLoadingMoreServices,
  });

  final List<Services> serviceList;
  final int totalServices;
  final Providers providerDetails;
  final bool isLoadingMoreServices;

  ProviderDetailsAndServiceFetchSuccess copyWith({
    final List<Services>? serviceList,
    final int? totalServices,
    final Providers? providerDetails,
    final bool? isLoadingMoreServices,
  }) =>
      ProviderDetailsAndServiceFetchSuccess(
          providerDetails: providerDetails ?? this.providerDetails,
          isLoadingMoreServices: isLoadingMoreServices ?? this.isLoadingMoreServices,
          serviceList: serviceList ?? this.serviceList,
          totalServices: totalServices ?? this.totalServices);
}

class ProviderDetailsAndServiceFetchFailure extends ProviderDetailsAndServiceState {
  ProviderDetailsAndServiceFetchFailure({required this.errorMessage});

  final String errorMessage;
}

class MoreServiceFetchFailure extends ProviderDetailsAndServiceState {
  MoreServiceFetchFailure({required this.errorMessage});

  final String errorMessage;
}

class ProviderDetailsAndServiceCubit extends Cubit<ProviderDetailsAndServiceState> {
  ProviderDetailsAndServiceCubit(this.serviceRepository, this.providerRepository)
      : super(ProviderDetailsAndServiceInitial());
  final ProviderRepository providerRepository;
  final ServiceRepository serviceRepository;

  Future<void> fetchProviderDetailsAndServices({final String? providerId}) async {
    emit(ProviderDetailsAndServiceFetchInProgress());
    try {
      Map<String, dynamic>? providerData, serviceData;
      //
      final List<Future> futureAPIs = <Future>[
        //fetch provider data
        providerRepository
            .fetchProviderList(isAuthTokenRequired: true, providerId: providerId)
            .then((final value) => providerData = value)
            .onError((final error, StackTrace stackTrace) {
          throw ApiException("somethingWentWrong");
        }),
        //service data
        serviceRepository
            .getServices(
              offset: "0",
              limit: limitOfAPIData,
              isAuthTokenRequired:
                  Hive.box(userDetailBoxKey).get(tokenIdKey) == null ? false : true,
              providerId: providerId ?? "0",
            )
            .then((final value) => serviceData = value)
            .onError((final error, final stackTrace) {
          throw ApiException("somethingWentWrong");
        }),
      ];

      await Future.wait(futureAPIs);

      return emit(
        ProviderDetailsAndServiceFetchSuccess(
          isLoadingMoreServices: false,
          providerDetails: (providerData?['providerList'] as List).isNotEmpty
              ? (providerData?['providerList'] as List).first
              : [],
          serviceList: serviceData?['services'] ?? [],
          totalServices: int.parse(serviceData?['totalServices'] ?? "0"),
        ),
      );
    } catch (e, st) {
      emit(ProviderDetailsAndServiceFetchFailure(errorMessage: e.toString()));
    }
  }

  Future<void> fetchMoreServices({final String? providerId}) async {
    try {
      //
      if (state is ProviderDetailsAndServiceFetchSuccess) {
        if ((state as ProviderDetailsAndServiceFetchSuccess).isLoadingMoreServices) {
          return;
        }
      }

      final ProviderDetailsAndServiceFetchSuccess currentState =
          state as ProviderDetailsAndServiceFetchSuccess;

      final List<Services> serviceData = currentState.serviceList;
      //
      emit(currentState.copyWith(isLoadingMoreServices: true));

      //service data
      final Map<String, dynamic> moreServicesData = await serviceRepository.getServices(
        offset: currentState.serviceList.length.toString(),
        limit: limitOfAPIData,
        isAuthTokenRequired: Hive.box(userDetailBoxKey).get(tokenIdKey) == null ? false : true,
        providerId: providerId!,
      );

      serviceData.addAll(moreServicesData['services']);

      return emit(
        currentState.copyWith(
          isLoadingMoreServices: false,
          serviceList: serviceData,
        ),
      );
    } catch (e) {
      emit(MoreServiceFetchFailure(errorMessage: e.toString()));
    }
  }

  bool hasMoreServices() {
    if (state is ProviderDetailsAndServiceFetchSuccess) {
      final bool hasMoreServices =
          (state as ProviderDetailsAndServiceFetchSuccess).serviceList.length <
              (state as ProviderDetailsAndServiceFetchSuccess).totalServices;

      return hasMoreServices;
    }
    return false;
  }

  String getProviderId() {
    if (state is ProviderDetailsAndServiceFetchSuccess) {
      return (state as ProviderDetailsAndServiceFetchSuccess).providerDetails.id.toString();
    }
    return "0";
  }

}
