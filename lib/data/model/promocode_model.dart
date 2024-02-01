import 'package:e_demand/utils/constant.dart';

class Promocode {
  Promocode({
    this.id,
    this.promoCode,
    this.message,
    this.startDate,
    this.endDate,
    this.noOfUsers,
    this.minimumOrderAmount,
    this.discount,
    this.discountType,
    this.maxDiscountAmount,
    this.repeatUsage,
    this.noOfRepeatUsage,
    this.image,
  });

  Promocode.fromJson(final Map<String, dynamic> json) {
    id = json["id"];
    promoCode = json["promo_code"];
    message = json["message"];
    startDate = json['start_date'].toString().split(" ").first;
    endDate = json['end_date'].toString().split(" ").first;
    noOfUsers = json["no_of_users"];
    minimumOrderAmount = json["minimum_order_amount"];
    discount = json["discount"];
    discountType = json["discount_type"] == "percentage"
        ? '%'
        : json["discount_type"] == "amount"
            ? systemCurrency
            : json["discount_type"];
    maxDiscountAmount = json["max_discount_amount"];
    repeatUsage = json["repeat_usage"];
    noOfRepeatUsage = json["no_of_repeat_usage"] ?? "1";
    image = json["image"];
    status = json["status"];
  }

  String? id;
  String? promoCode;
  String? message;
  String? startDate;
  String? endDate;
  String? noOfUsers;
  String? minimumOrderAmount;
  String? discount;
  String? discountType;
  String? maxDiscountAmount;
  String? repeatUsage;
  String? noOfRepeatUsage;
  String? image;
  String? status;
}
