import 'package:e_demand/app/generalImports.dart';

class ReviewRepository {
  //
  ///This method is used to fetch available Reviews form database
  Future<Map<String, dynamic>> getReviews({
    required final bool isAuthTokenRequired,
    String? providerId,
    String? serviceId,
  }) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.partnerId: providerId,
        Api.serviceId: serviceId,
        Api.order: "DESC",
        Api.sort: "created_at",
        Api.offset: "0",
        Api.limit: "100"
      };

      if (serviceId == null) {
        parameter.remove(Api.serviceId);
      }
      final response = await Api.post(
        parameter: parameter,
        url: Api.getReview,
        useAuthToken: isAuthTokenRequired,
      );

      if (response.isEmpty) {
        return {"Reviews": [], "totalReviews": 0};
      }

      return {
        "Reviews":
            (response['data'] as List).map((final e) => Reviews.fromJson(Map.from(e))).toList(),
        "totalReviews": response['total']
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
