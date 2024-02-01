import 'package:dio/dio.dart';

import "../app/generalImports.dart";

class ApiException implements Exception {
  ApiException(this.errorMessage);

  String errorMessage;

  @override
  String toString() => errorMessage;
}

class Api {
  //headers
  static Map<String, dynamic> headers() {
    final String jwtToken = Hive.box(userDetailBoxKey).get(tokenIdKey) ?? "";
    if (kDebugMode) {
      print("token is $jwtToken");
    }
    return {"Authorization": "Bearer $jwtToken"};
  }

  ///API list
  static String getServices = "${baseUrl}get_services";
  static String getSliderImages = "${baseUrl}get_sliders";
  static String getSubCategories = "${baseUrl}get_sub_categories";
  static String getReview = "${baseUrl}get_ratings";
  static String getCategories = "${baseUrl}get_categories";
  static String getNotifications = "${baseUrl}get_notifications";
  static String getSections = "${baseUrl}get_sections";
  static String getProviders = "${baseUrl}get_providers";
  static String getHomeScreenData = "${baseUrl}get_home_screen_data";
  static String getCart = "${baseUrl}get_cart";
  static String getAddress = "${baseUrl}get_address";
  static String addAddress = "${baseUrl}add_address";
  static String deleteAddress = "${baseUrl}delete_address";
  static String isCityDeliverable = "${baseUrl}is_city_deliverable";
  static String bookMark = "${baseUrl}book_mark";
  static String updateUser = "${baseUrl}update_user";
  static String updateFCM = "${baseUrl}update_fcm";
  static String manageCart = "${baseUrl}manage_cart";
  static String manageNotification = "${baseUrl}manage_notification";
  static String manageUser = "${baseUrl}manage_user";
  static String removeFromCart = "${baseUrl}remove_from_cart";
  static String getAvailableSlots = "${baseUrl}get_available_slots";
  static String placeOrder = "${baseUrl}place_order";
  static String getPromocode = "${baseUrl}get_promo_codes";
  static String validatePromocode = "${baseUrl}validate_promo_code";
  static String getSystemSettings = "${baseUrl}get_settings";
  static String getfandqSettings = "${baseUrl}get_faqs";
  static String createRazorpayOrder = "${baseUrl}razorpay_create_order";
  static String getOrderBooking = "${baseUrl}get_orders";
  static String addTransaction = "${baseUrl}add_transaction";
  static String addRating = "${baseUrl}add_rating";
  static String verifyUser = "${baseUrl}verify_user";
  static String changeBookingStatus = "${baseUrl}update_order_status";
  static String validateCustomTime = "${baseUrl}check_available_slot";
  static String getTransactions = "${baseUrl}get_transactions";
  static String deleteUserAccount = "${baseUrl}delete_user_account";
  static String checkProviderAvailability = "${baseUrl}provider_check_availability";
  static String downloadInvoice = "${baseUrl}invoice-download";

  ///API parameter
  static const String limit = "limit";
  static const String name = "name";
  static const String longitude = "longitude";
  static const String latitude = "latitude";
  static const String mobile = "mobile";
  static const String countryCode = "country_code";
  static const String notificationId = "notification_id";
  static const String offset = "offset";
  static const String pincode = "pincode";
  static const String state = "state";

  static const String type = "type";
  static const String isDefault = "is_default";
  static const String isReadedNotification = "is_readed";
  static const String landmark = "landmark";
  static const String lattitude = "lattitude";
  static const String address = "address";
  static const String addressId = "address_id";
  static const String alternateMobile = "alternate_mobile";
  static const String area = "area";
  static const String categoryId = "category_id";
  static const String providerId = "provider_id";
  static const String filter = "filter";
  static const String sort = "sort";
  static const String order = "order";
  static const String subCategoryId = "sub_category_id";
  static const String cityId = "city_id";
  static const String country = "country";
  static const String deleteNotification = "delete_notification";
  static const String image = "image";
  static const String username = "username";
  static const String email = "email";
  static const String fcmId = "fcm_id";
  static const String platform = "platform";
  static const String partnerId = "partner_id";
  static const String qty = "qty";
  static const String serviceId = "service_id";
  static const String date = "date";
  static const String promocode = "promo_code";
  static const String totalAmount = "final_total";
  static const String orderId = "order_id";
  static const String search = "search";
  static const String status = "status";
  static const String rating = "rating";
  static const String comment = "comment";
  static const String time = "time";
  static const String listOfImage = "images[]";
  static const String isCheckoutProcess = "is_checkout_process";

////////* Place API */////
  static const String _placeApiBaseUrl = "https://maps.googleapis.com/maps/api/place/";
  static String placeApiKey = "key";

  static const String input = "input";
  static const String types = "types";
  static const String placeid = "placeid";
  static String placeAPI = "${_placeApiBaseUrl}autocomplete/json";
  static String placeApiDetails = "${_placeApiBaseUrl}details/json";

  ///post method for API calling
  static Future<Map<String, dynamic>> post({
    required final String url,
    required final Map<String, dynamic> parameter,
    required final bool useAuthToken,
    final b,
  }) async {
    try {
      //
      final Dio dio = Dio();

      final FormData formData = FormData.fromMap(parameter, ListFormat.multiCompatible);

      if (kDebugMode) {
        print("API is $url \n pra are $parameter \n ");
      }

      final response = await dio.post(
        url,
        data: formData,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      /*  if (response.data['error']) {
        throw ApiException(response.data['message']);
      }*/

      if (kDebugMode) {
        print("API is $url \n pra are $parameter \n response is $response");
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print("error API is $url");

        print("error is ${e.response} ${e.message}");
      }
      if (e.response?.statusCode == 401) {
        throw ApiException("authenticationFailed");
      } else if (e.response?.statusCode == 500) {
        throw ApiException("internalServerError");
      }
      throw ApiException(e.error is SocketException ? "noInternetFound" : "somethingWentWrong");
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e, st) {
      if (kDebugMode) {
        print("api $e ${st.toString()}");
      }
      throw ApiException("somethingWentWrong");
    }
  }

  ///post method for API calling
  static Future<List<int>> downloadAPI({
    required final String url,
    required final Map<String, dynamic> parameter,
    required final bool useAuthToken,
    final bool? isInvoiceAPI,
  }) async {
    try {
      //
      final Dio dio = Dio();

      final FormData formData = FormData.fromMap(parameter, ListFormat.multiCompatible);

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers(), responseType: ResponseType.bytes),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ApiException("authenticationFailed");
      } else if (e.response?.statusCode == 500) {
        throw ApiException("internalServerError");
      } else if (e.response?.statusCode == 503) {
        throw ApiException("internalServerError");
      }
      throw ApiException(e.error is SocketException ? "noInternetFound" : "somethingWentWrong");
    } on ApiException {
      throw ApiException("somethingWentWrong");
    } catch (e) {
      throw ApiException("somethingWentWrong");
    }
  }

  static Future<Map<String, dynamic>> get({
    required final String url,
    required final bool useAuthToken,
    final Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //
      final Dio dio = Dio();

      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: useAuthToken ? Options(headers: headers()) : null,
      );

      if (response.data['error'] == true) {
        throw ApiException(response.data['code'].toString());
      }

      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw ApiException("authenticationFailed");
      } else if (e.response?.statusCode == 500) {
        throw ApiException("internalServerError");
      }
      throw ApiException(e.error is SocketException ? "noInternetFound" : "somethingWentWrong");
    } on ApiException {
      throw ApiException("somethingWentWrong");
    } catch (e) {
      throw ApiException("somethingWentWrong");
    }
  }
}
