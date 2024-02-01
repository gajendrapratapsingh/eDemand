import 'package:dio/dio.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:path/path.dart' as p;

class UserRepository {
  Future<Map<String, dynamic>> updateUserDetails(final UpdateUserDetails model) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.username: model.username,
        Api.mobile: model.phone,
        Api.countryCode: model.countryCode,
        Api.email: model.email,
      };

      if (model.image != "") {
        final mimeType = lookupMimeType(model.image!.path);
        final extension = mimeType!.split("/");

        parameter[Api.image] = await MultipartFile.fromFile(
          model.image!.path,
          filename: p.basename(model.image!.path),
          contentType: MediaType('image', extension[1]),
        );
      }

      final Map<String, dynamic> response =
          await Api.post(url: Api.updateUser, parameter: parameter, useAuthToken: true);

      if (response['error']) {
        throw ApiException(response['message'].toString());
      }
      await Hive.box(userDetailBoxKey).putAll({
        userNameKey: response['data']["username"],
        countryCodeKey: response['data']["country_code"],
        profileImageKey: response['data']["image"],
        phoneNumberKey: response['data']["phone"],
        emailIdKey: response['data']["email"]
      });
      return {
        "data": response['data'],
        'message': response['message'].toString(),
        "error": response['error'],
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future updateFCM({
    required final String fcmId,
    required final String platform,
  }) async {
    try {
      final Map<String, dynamic> parameters = <String, dynamic>{
        Api.fcmId: fcmId,
        Api.platform: platform
      };

      await Api.post(url: Api.updateFCM, parameter: parameters, useAuthToken: true);
      //
    } catch (_) {
      //
    }
  }
}
