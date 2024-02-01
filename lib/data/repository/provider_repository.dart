import 'package:e_demand/app/generalImports.dart';

class ProviderRepository {
  //
  /// This method is used to fetch Provider List
  Future<Map<String, dynamic>> fetchProviderList({
    required final bool isAuthTokenRequired,
    final String? categoryId,
    final String? providerId,
    final String? subCategoryId,
    final String? filter,
  }) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
        Api.longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString()
      };

      if (categoryId != "" && categoryId != null) {
        parameter[Api.categoryId] = categoryId;
      }
      if (providerId != "" && providerId != null) {
        parameter[Api.partnerId] = providerId;
      }
      if (subCategoryId != "" && subCategoryId != null) {
        parameter[Api.subCategoryId] = subCategoryId;
      }
      if (filter != "" && filter != null) {
        parameter[Api.filter] = filter;
        // parameter[Api.order] = "desc";
      }
      //
      final providers =
          await Api.post(url: Api.getProviders, parameter: parameter, useAuthToken: false);

      return {
        'totalProviders': providers['total'].toString(),
        'providerList': (providers['data'] as List).map((providerData) {
          return Providers.fromJson(providerData);
        }).toList()
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }


  //
  /// This method is used to search Provider
  Future<Map<String, dynamic>> searchProvider({
    required final String searchKeyword,
    required final String offset,
    required final String limit,
  }) async {
    try {
      final parameter = <String, dynamic>{
        Api.latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
        Api.longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString(),
        Api.search: searchKeyword,
        Api.limit: limit,
        Api.offset: offset,
      };

      final providers =
          await Api.post(url: Api.getProviders, parameter: parameter, useAuthToken: false);
      //
      return {
        'totalProviders': providers['total'].toString(),
        'providerList': (providers['data'] as List).map((providerData) {
          return Providers.fromJson(providerData);
        }).toList()
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  /// This method is used to check providers are available at selected latitude longitude
  Future<Map<String, dynamic>> checkProviderAvailability({
    required final String latitude,
    required final String longitude,
    required final String checkingAtCheckOut,
    final String? orderId,
    required final bool isAuthTokenRequired,
  }) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.latitude: latitude,
        Api.longitude: longitude,
        Api.isCheckoutProcess: checkingAtCheckOut,
        Api.orderId: orderId
      };

      final response = await Api.post(
        url: Api.checkProviderAvailability,
        parameter: parameter,
        useAuthToken: isAuthTokenRequired,
      );
      return {
        'error': response['error'],
        'message': response['message'].toString(),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
