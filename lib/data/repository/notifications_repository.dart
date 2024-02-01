import 'package:e_demand/app/generalImports.dart';

class NotificationsRepository {
  //
  Future<Map<String, dynamic>> getNotifications(
      {required final String limit, required final String offset,}) async {
    try {
      final parameters = <String, dynamic>{Api.limit: limit, Api.offset: offset};

      final Map<String, dynamic> response =
          await Api.post(url: Api.getNotifications, parameter: parameters, useAuthToken: true);

      //
      //if data is not available then we will return empty data
      if (response["data"].isEmpty) {
        return {"notificationList": <NotificationDataModel>[], "totalNotifications": "0"};
      }
      //
      return {
        "notificationList": (response["data"] as List)
            .map((final value) => NotificationDataModel.fromJson(Map.from(value)))
            .toList(),
        "totalNotifications": response['total'].toString()
      };
    } catch (error) {
      throw ApiException(error.toString());
    }
  }

  Future<Map<String, dynamic>> deleteNotification(
      {required final String id, required final bool isAuthTokenRequired,}) async {
    try {
      final Map<String, dynamic> parameters = <String, dynamic>{
        Api.notificationId: id,
        Api.deleteNotification: 1,
      };
      final Map<String, dynamic> response = await Api.post(
          url: Api.manageNotification, parameter: parameters, useAuthToken: isAuthTokenRequired,);

      return {'error': response['error'], 'message': response['message']};
    } catch (error) {
      throw ApiException(error.toString());
    }
  }

  Future<Map<String, dynamic>> markNotificationAsRead(
      {required final String id, required final bool isAuthTokenRequired,}) async {
    try {
      final Map<String, dynamic> parameters = <String, dynamic>{
        Api.notificationId: id,
        Api.isReadedNotification: 1,
      };
      final Map<String, dynamic> response = await Api.post(
          url: Api.manageNotification, parameter: parameters, useAuthToken: isAuthTokenRequired,);

      return {'error': response['error'], 'message': response['message']};
    } catch (error) {
      throw ApiException(error.toString());
    }
  }
}
