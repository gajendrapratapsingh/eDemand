import 'package:dio/dio.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:path/path.dart' as p;

class BookingRepository {
  //
  ///This method is used to fetch booking details
  Future<Map<String, dynamic>> fetchBookingDetails({
    required final Map<String, dynamic> parameter,
  }) async {
    try {
      final response =
          await Api.post(parameter: parameter, url: Api.getOrderBooking, useAuthToken: true);

      if (response['error']) {
        return {"bookingDetails": <Booking>[], "totalBookings": 0};
      }

      return {
        "bookingDetails":
            (response['data'] as List).map((final e) => Booking.fromJson(Map.from(e))).toList(),
        "totalBookings": int.parse(response['total'])
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  ///This method is used to add rating to the service
  Future<Map<String, dynamic>> submitReviewToService({
    required final String serviceId,
    required final String ratingStar,
    required final String reviewComment,
    final List<XFile?>? reviewImages,
  }) async {
    try {
      final parameter = <String, dynamic>{
        Api.comment: reviewComment,
        Api.rating: ratingStar,
        Api.serviceId: serviceId,
        Api.listOfImage: reviewImages,
      };
      //
      if (reviewImages != null) {
        final list = [];
        for (int i = 0; i < reviewImages.length; i++) {
          final XFile? element = reviewImages[i];
          //
          final mimeType = lookupMimeType(element!.path);
          final extension = mimeType!.split("/");
          //
          final imagePart = await MultipartFile.fromFile(
            element.path,
            filename: p.basename(element.path),
            contentType: MediaType('image', extension[1]),
          );
          list.add(imagePart);
          parameter["images[$i]"] = imagePart;
        }
      }
      final response = await Api.post(parameter: parameter, url: Api.addRating, useAuthToken: true);

      return {"error": response['error'], "message": response['message']};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  ///This method is used to change booking status
  Future<Map<String, dynamic>> changeBookingStatus(
      {required final String bookingStatus,
      required final String bookingId,
      String? selectedDate,
      String? selectedTime}) async {
    try {
      final parameter = <String, dynamic>{
        Api.orderId: bookingId,
        Api.status: bookingStatus,
        Api.date: selectedDate,
        Api.time: selectedTime
      };

      final response =
          await Api.post(parameter: parameter, url: Api.changeBookingStatus, useAuthToken: true);

      return {
        "bookingData" : response["error"] ? {}: response["data"]["data"][0] ?? {},
        "error": response['error'], "message": response['message']};
    } catch (e) {

      throw ApiException(e.toString());
    }
  }

  //
  ///This method is used to download invoice
  Future<List<int>> downloadInvoice({
    required final String bookingId,
  }) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        Api.orderId: bookingId,
      };

      final response =
          await Api.downloadAPI(parameter: parameter, url: Api.downloadInvoice, useAuthToken: true);

      return response;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  ///This method is used to add online payment transaction
  Future<Map<String, dynamic>> addOnlinePaymentTransaction({
    required final Map<String, dynamic> parameter,
  }) async {
    try {
      final response =
          await Api.post(parameter: parameter, url: Api.addTransaction, useAuthToken: true);

      return {"message": response['message'], "error": response['error']};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
