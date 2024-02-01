import 'package:dio/dio.dart';
import 'package:e_demand/app/generalImports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String? secret;

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static Map<String, String> getHeaders() => {
      "Authorization": "Bearer ${StripeService.secret}",
      "Content-Type": "application/x-www-form-urlencoded"
    };

  static void init(final String? stripeId, final String? stripeMode) {
    Stripe.publishableKey = stripeId ?? '';
  }

  static Future<StripeTransactionResponse> payWithPaymentSheet(
      {required final int amount,
      required final bool isTestEnvironment, final String? currency,
      final String? from,
      final BuildContext? context,
      final String? awaitedOrderId,}) async {
    try {
      //create Payment intent
      final Map<String, dynamic>? paymentIntent = await StripeService.createPaymentIntent(
          amount: amount,
          currency: currency,
          from: from,
          context: context,
          awaitedOrderID: awaitedOrderId,);
      //setting up Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              allowsDelayedPaymentMethods: true,
              style: ThemeMode.light,
              merchantDisplayName: appName,),);

      //open payment sheet
      await Stripe.instance.presentPaymentSheet();

      //confirm payment
       final Response response = await Dio().post('${StripeService.paymentApiUrl}/${paymentIntent['id']}',
          options: Options(headers: headers),);

        final Map getdata = Map.from(response.data);
      final statusOfTransaction = getdata['status'];

      if (statusOfTransaction == 'succeeded') {
        return StripeTransactionResponse(
            message: 'Transaction successful', success: true, status: statusOfTransaction,);
      } else if (statusOfTransaction == 'pending' || statusOfTransaction == 'captured') {
        return StripeTransactionResponse(
            message: 'Transaction pending', success: true, status: statusOfTransaction,);
      } else {
        return StripeTransactionResponse(
            message: 'Transaction failed', success: false, status: statusOfTransaction,);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (error) {
      return StripeTransactionResponse(
          message: 'Transaction failed: $error', success: false, status: 'fail',);
    }
  }

  static StripeTransactionResponse getPlatformExceptionErrorResult(final err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return StripeTransactionResponse(message: message, success: false, status: 'cancelled');
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(
      {required final int amount,
      final String? currency,
      final String? from,
      final BuildContext? context,
      final String? awaitedOrderID,}) async {
    try {
      final Map<String, dynamic> parameter = <String, dynamic>{
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': "payment",
      };

      if (from == 'order') parameter['metadata[order_id]'] = awaitedOrderID;

       final Dio dio = Dio();

      final   response = await dio.post(StripeService.paymentApiUrl,
          data: parameter, options: Options(headers: StripeService.getHeaders()),);

      return Map.from(response.data);
    } catch (_) {}
    return null;
  }
}

class StripeTransactionResponse {

  StripeTransactionResponse({this.message, this.success, this.status});
  final String? message, status;
  bool? success;
}
