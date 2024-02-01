import 'package:e_demand/app/generalImports.dart';

class ServiceRepository {
  //
  ///This method is used to fetch available services form database
  Future<Map<String, dynamic>> getServices({
    required final String offset,
    required final String limit,
    required final bool isAuthTokenRequired,
    /* String? search,*/ required final String providerId,
  }) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
        Api.longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString(),
        Api.partnerId: providerId,
        Api.limit: limit,
        Api.offset: offset
      };

      final response = await Api.post(
        parameter: parameter,
        url: Api.getServices,
        useAuthToken: isAuthTokenRequired,
      );

      if (response.isEmpty) {
        return {"services": [], "totalServices": 0};
      }
      return {
        "services":
            (response['data'] as List).map((final e) => Services.fromJson(Map.from(e))).toList(),
        "totalServices": response['total']
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
