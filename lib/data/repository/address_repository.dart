// ignore_for_file: file_names

import 'package:e_demand/app/generalImports.dart';

class AddressRepository {
  Future<Map<String, dynamic>> addAddress(final AddressModel addressDataModel) async {
    try {
      //

      final demo = addressDataModel.toMap();
      //
      demo["lattitude"] = addressDataModel.latitude;
      //

      //
      final response = await Api.post(url: Api.addAddress, parameter: demo, useAuthToken: true);
//

      return response;
      //
    } catch (e) {
      //
      throw ApiException(e.toString());
      //
    }
  }

  Future<List<GetAddressModel>> fetchAddress() async {
    try {
      //
      final Map<String, dynamic> response = await Api.post(
          url: Api.getAddress, parameter: {Api.limit: 100, Api.offset: 0}, useAuthToken: true,);

      //
      //
      final List<GetAddressModel> mappedResponse = (response['data'] as List<dynamic>).map((final entry) {
        final  getAddressModel = GetAddressModel.fromJson(entry);

        return getAddressModel;
      }).toList();

      return mappedResponse;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future deleteAddress(final String id) async {
    final Map<String, dynamic> parameter = <String, dynamic>{Api.addressId: id};
    try {
      await Api.post(url: Api.deleteAddress, parameter: parameter, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> isCityDeliverable(final String name) async {
    try {
      final apiResponse = await Api.post(
          url: Api.isCityDeliverable, parameter: {Api.name: name}, useAuthToken: true,);
      return apiResponse;
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }
}
