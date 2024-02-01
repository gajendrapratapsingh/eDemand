import 'package:e_demand/app/generalImports.dart';

class SystemRepository {
  //
  ///This method is used to fetch Slider Images
  Future<Map<String, dynamic>> getSliderImages(final bool isAuthTokenRequired) async {
    try {
      final response = await Api.post(
        url: Api.getSliderImages,
        parameter: {},
        useAuthToken: isAuthTokenRequired,
      );

      return {
        "sliderImages": (response['data'] as List)
            .map((final e) => SliderImages.fromJson(Map.from(e)))
            .toList(),
        "totalSliderImages": response['total']
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getFAndQ({required Map<String, dynamic> parameter}) async {
    try {
      final response = await Api.post(
        url: Api.getfandqSettings,
        parameter: parameter,
        useAuthToken: false,
      );

      return {
        "fAndQData":
            (response['data'] as List).map((final e) => Faqs.fromJson(Map.from(e))).toList(),
        "totalFaqs": int.parse((response['total'] ?? "0").toString())
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getUserPaymentDetails(
      {required final Map<String, dynamic> parameter}) async {
    try {
      //
      final response =
          await Api.post(url: Api.getTransactions, parameter: parameter, useAuthToken: true);

      return {
        "paymentDetails":
            (response['data'] as List).map((final e) => Payment.fromJson(Map.from(e))).toList(),
        "total": response['total'] == null ? 0 : int.parse(response['total'].toString())
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
