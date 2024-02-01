import 'package:flutter/foundation.dart';

class Booking {
  String? id;
  String? customer;
  String? customerId;
  String? customerNo;
  String? customerEmail;
  String? userWallet;
  String? paymentMethod;
  String? partner;
  String? profileImage;
  String? userId;
  String? partnerId;
  String? cityId;
  String? total;
  String? taxPercentage;
  String? taxAmount;
  String? promoCode;
  String? promoDiscount;
  String? finalTotal;
  String? adminEarnings;
  String? partnerEarnings;
  String? addressId;
  String? address;
  String? dateOfService;
  String? startingTime;
  String? endingTime;
  String? duration;
  String? status;
  String? providerAdvanceBookingDays;
  String? otp;
  List<dynamic>? workStartedProof;
  List<dynamic>? workCompletedProof;
  String? providerAddress;
  String? providerLatitude;
  String? providerLongitude;
  String? providerNumber;
  String? remarks;
  String? createdAt;
  String? companyName;
  String? visitingCharges;
  List<BookedService>? services;
  String? invoiceNo;
  String? isCancelable;
  String? newStartTimeWithDate;
  String? newEndTimeWithDate;
  String? isReorderAllowed;
  List<MultipleDayBookingData>? multipleDaysBooking;
  Key? key = UniqueKey();

  Booking({
    this.id,
    this.key,
    this.customer,
    this.customerId,
    this.customerNo,
    this.customerEmail,
    this.userWallet,
    this.paymentMethod,
    this.partner,
    this.profileImage,
    this.userId,
    this.partnerId,
    this.cityId,
    this.isCancelable,
    this.total,
    this.taxPercentage,
    this.taxAmount,
    this.promoCode,
    this.promoDiscount,
    this.finalTotal,
    this.adminEarnings,
    this.partnerEarnings,
    this.addressId,
    this.address,
    this.dateOfService,
    this.startingTime,
    this.endingTime,
    this.duration,
    this.status,
    this.otp,
    this.remarks,
    this.createdAt,
    this.companyName,
    this.visitingCharges,
    this.services,
    this.invoiceNo,
    this.workCompletedProof,
    this.workStartedProof,
    this.multipleDaysBooking,
    this.newEndTimeWithDate,
    this.newStartTimeWithDate,
    this.providerNumber,
    this.providerAddress,
    this.providerLatitude,
    this.providerAdvanceBookingDays,
    this.providerLongitude,
    this.isReorderAllowed,
  });

  Booking.fromJson(final Map<String, dynamic> json) {
    id = json["id"];
    customer = json["customer"];
    customerId = json["customer_id"];
    customerNo = json["customer_no"];
    customerEmail = json["customer_email"];
    userWallet = json["user_wallet"];
    paymentMethod = json["payment_method"];
    partner = json["partner"];
    profileImage = json["profile_image"];
    userId = json["user_id"];
    partnerId = json["partner_id"];
    cityId = json["city_id"];
    total = json["total"];
    taxPercentage = json["tax_percentage"];
    taxAmount = json["tax_amount"];
    promoCode = json["promo_code"];
    promoDiscount = json["promo_discount"];
    finalTotal = json["final_total"].toString();
    adminEarnings = json["admin_earnings"];
    partnerEarnings = json["partner_earnings"];
    addressId = json["address_id"];
    address = json["address"];
    dateOfService = json["date_of_service"];
    startingTime = json["starting_time"];
    endingTime = json["ending_time"];
    duration = json["duration"];
    status = json["status"];
    otp = json["otp"] != '' ? json["otp"] : '--';
    remarks = json["remarks"];
    createdAt = json["created_at"];
    companyName = json["company_name"];
    visitingCharges = json["visiting_charges"];
    workStartedProof = json["work_started_proof"];
    workCompletedProof = json["work_completed_proof"];
    isReorderAllowed = json["is_reorder_allowed"];
    providerAdvanceBookingDays = json["advance_booking_days"];
    invoiceNo = json["invoice_no"];
    isCancelable = json["is_cancelable"].toString();
    providerAddress = json["partner_address"];
    providerLatitude = json["partner_latitude"] != null && json["partner_latitude"] != ""
        ? json["partner_latitude"]
        : "0.0";
    providerLongitude = json["partner_longitude"] != null && json["partner_longitude"] != ""
        ? json["partner_longitude"]
        : "0.0";
    providerNumber = json["partner_no"];
    newStartTimeWithDate = json['new_start_time_with_date'] ?? '';
    newEndTimeWithDate = json['new_end_time_with_date'] ?? '';

    if (json["services"] != null) {
      services = <BookedService>[];
      json["services"].forEach((final v) {
        services!.add(BookedService.fromJson(v));
      });
    }
    if (json["multiple_days_booking"] != null) {
      multipleDaysBooking = <MultipleDayBookingData>[];
      json["multiple_days_booking"].forEach((final v) {
        multipleDaysBooking!.add(MultipleDayBookingData.fromJson(v));
      });
    }
  }

  Booking copyWith({
    String? id,
    String? customer,
    String? customerId,
    String? latitude,
    String? longitude,
    String? partnerLatitude,
    String? partnerLongitude,
    String? advanceBookingDays,
    String? customerNo,
    String? customerEmail,
    String? userWallet,
    String? paymentMethod,
    String? paymentStatus,
    String? partner,
    String? profileImage,
    String? userId,
    String? partnerId,
    String? cityId,
    String? total,
    String? taxAmount,
    String? promoCode,
    String? promoDiscount,
    String? finalTotal,
    String? adminEarnings,
    String? partnerEarnings,
    String? addressId,
    String? address,
    String? dateOfService,
    String? startingTime,
    String? endingTime,
    String? duration,
    String? partnerAddress,
    String? partnerNo,
    String? serviceImage,
    String? otp,
    List<dynamic>? workStartedProof,
    List<dynamic>? workCompletedProof,
    int? isCancelable,
    String? status,
    String? remarks,
    String? createdAt,
    String? companyName,
    String? visitingCharges,
    String? isOtpEnalble,
    List<BookedService>? services,
    String? newStartTimeWithDate,
    String? newEndTimeWithDate,
    List<MultipleDayBookingData>? multipleDaysBooking,
    String? invoiceNo,
  }) =>
      Booking(
        id: id ?? this.id,
        customer: customer ?? this.customer,
        customerId: customerId ?? this.customerId,
        providerLatitude: partnerLatitude ?? providerLatitude,
        providerLongitude: partnerLongitude ?? providerLongitude,
        providerAdvanceBookingDays: advanceBookingDays ?? providerAdvanceBookingDays,
        customerNo: customerNo ?? this.customerNo,
        customerEmail: customerEmail ?? this.customerEmail,
        userWallet: userWallet ?? this.userWallet,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        partner: partner ?? this.partner,
        profileImage: profileImage ?? this.profileImage,
        userId: userId ?? this.userId,
        partnerId: partnerId ?? this.partnerId,
        cityId: cityId ?? this.cityId,
        total: total ?? this.total,
        taxAmount: taxAmount ?? this.taxAmount,
        promoCode: promoCode ?? this.promoCode,
        promoDiscount: promoDiscount ?? this.promoDiscount,
        finalTotal: finalTotal ?? this.finalTotal,
        adminEarnings: adminEarnings ?? this.adminEarnings,
        partnerEarnings: partnerEarnings ?? this.partnerEarnings,
        addressId: addressId ?? this.addressId,
        address: address ?? this.address,
        dateOfService: dateOfService ?? this.dateOfService,
        startingTime: startingTime ?? this.startingTime,
        endingTime: endingTime ?? this.endingTime,
        duration: duration ?? this.duration,
        otp: otp ?? this.otp,
        workStartedProof: workStartedProof ?? this.workStartedProof,
        workCompletedProof: workCompletedProof ?? this.workCompletedProof,
        isCancelable: (isCancelable ?? this.isCancelable).toString(),
        status: status ?? this.status,
        remarks: remarks ?? this.remarks,
        createdAt: createdAt ?? this.createdAt,
        companyName: companyName ?? this.companyName,
        visitingCharges: visitingCharges ?? this.visitingCharges,
        services: services ?? this.services,
        newStartTimeWithDate: newStartTimeWithDate ?? this.newStartTimeWithDate,
        newEndTimeWithDate: newEndTimeWithDate ?? this.newEndTimeWithDate,
        multipleDaysBooking: multipleDaysBooking ?? this.multipleDaysBooking,
        invoiceNo: invoiceNo ?? this.invoiceNo,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> booking = <String, dynamic>{};
    booking['id'] = id;
    booking['customer'] = customer;
    booking['customer_id'] = customerId;
    booking['customer_no'] = customerNo;
    booking['customer_email'] = customerEmail;
    booking['user_wallet'] = userWallet;
    booking['payment_method'] = paymentMethod;
    booking['partner'] = partner;
    booking['profile_image'] = profileImage;
    booking['user_id'] = userId;
    booking['partner_id'] = partnerId;
    booking['city_id'] = cityId;
    booking['total'] = total;
    booking['tax_percentage'] = taxPercentage;
    booking['tax_amount'] = taxAmount;
    booking['promo_code'] = promoCode;
    booking['promo_discount'] = promoDiscount;
    booking['final_total'] = finalTotal;
    booking['admin_earnings'] = adminEarnings;
    booking['partner_earnings'] = partnerEarnings;
    booking['address_id'] = addressId;
    booking['address'] = address;
    booking['date_of_service'] = dateOfService;
    booking['starting_time'] = startingTime;
    booking['ending_time'] = endingTime;
    booking['duration'] = duration;
    booking['status'] = status;
    booking['otp'] = otp;
    booking['remarks'] = remarks;
    booking['created_at'] = createdAt;
    booking['company_name'] = companyName;
    booking['visiting_charges'] = visitingCharges;
    booking['work_completed_proof'] = workCompletedProof;
    booking['work_started_proof'] = workStartedProof;
    if (services != null) {
      booking['services'] = services!.map((final v) => v.toJson()).toList();
    }
    booking['invoice_no'] = invoiceNo;
    booking["advance_booking_days"] = providerAdvanceBookingDays;
    return booking;
  }
}

class MultipleDayBookingData {
  MultipleDayBookingData({
    this.multipleDayDateOfService,
    this.multipleDayStartingTime,
    this.multipleEndingTime,
  });

  MultipleDayBookingData.fromJson(final Map<String, dynamic> json) {
    multipleDayDateOfService = json['multiple_day_date_of_service'] ?? '';
    multipleDayStartingTime = json['multiple_day_starting_time'] ?? '';
    multipleEndingTime = json['multiple_ending_time'] ?? '';
  }

  MultipleDayBookingData copyWith({
    String? multipleDayDateOfService,
    String? multipleDayStartingTime,
    String? multipleEndingTime,
  }) =>
      MultipleDayBookingData(
        multipleDayDateOfService: multipleDayDateOfService ?? this.multipleDayDateOfService,
        multipleDayStartingTime: multipleDayStartingTime ?? this.multipleDayStartingTime,
        multipleEndingTime: multipleEndingTime ?? this.multipleEndingTime,
      );

  String? multipleDayDateOfService;
  String? multipleDayStartingTime;
  String? multipleEndingTime;

  Map<String, dynamic> toJson() => {
        "multiple_day_date_of_service": multipleDayDateOfService,
        "multiple_day_starting_time": multipleDayStartingTime,
        "multiple_ending_time": multipleEndingTime,
      };
}

class BookedService {
  BookedService({
    this.id,
    this.orderId,
    this.serviceId,
    this.serviceTitle,
    this.taxPercentage,
    this.taxAmount,
    this.price,
    this.originalPriceWithTax,
    this.discountPrice,
    this.priceWithTax,
    this.quantity,
    this.subTotal,
    this.status,
    this.tags,
    this.duration,
    this.categoryId,
    this.rating,
    this.comment,
    this.image,
  });

  BookedService copyWith({
    String? id,
    String? orderId,
    String? serviceId,
    String? serviceTitle,
    String? taxPercentage,
    String? discountPrice,
    String? taxAmount,
    String? price,
    String? quantity,
    String? subTotal,
    String? status,
    String? tags,
    String? duration,
    String? categoryId,
    String? isCancelable,
    String? cancelableTill,
    String? title,
    String? taxType,
    String? taxId,
    String? image,
    String? rating,
    String? comment,
    String? images,
    String? priceWithTax,
    String? taxValue,
    String? originalPriceWithTax,
  }) =>
      BookedService(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        serviceId: serviceId ?? this.serviceId,
        serviceTitle: serviceTitle ?? this.serviceTitle,
        taxPercentage: taxPercentage ?? this.taxPercentage,
        discountPrice: discountPrice ?? this.discountPrice,
        taxAmount: taxAmount ?? this.taxAmount,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        subTotal: subTotal ?? this.subTotal,
        status: status ?? this.status,
        tags: tags ?? this.tags,
        duration: duration ?? this.duration,
        categoryId: categoryId ?? this.categoryId,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        image: images ?? this.image,
        priceWithTax: priceWithTax ?? this.priceWithTax,
        originalPriceWithTax: originalPriceWithTax ?? this.originalPriceWithTax,
      );

  BookedService.fromJson(final Map<String, dynamic> json) {
    id = json["id"];
    orderId = json["order_id"];
    serviceId = json["service_id"];
    serviceTitle = json["service_title"];
    taxPercentage = json["tax_percentage"];
    taxAmount = json["tax_amount"];
    price = json["price"];
    discountPrice = json["discount_price"];
    priceWithTax = json["price_with_tax"];
    originalPriceWithTax = json["original_price_with_tax"];
    quantity = json["quantity"];
    subTotal = json["sub_total"];
    status = json["status"];
    tags = json["tags"];
    duration = json["duration"];
    categoryId = json["category_id"];
    rating = json["rating"] != "" ? json["rating"] : "0";
    comment = json["comment"];
    image = json["image"];
  }

  String? id;
  String? orderId;
  String? serviceId;
  String? serviceTitle;
  String? taxPercentage;
  String? taxAmount;
  String? discountPrice;
  String? price;
  String? originalPriceWithTax;
  String? priceWithTax;
  String? quantity;
  String? subTotal;
  String? status;
  String? tags;
  String? duration;
  String? categoryId;
  String? rating;
  String? comment;
  String? image;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> booking = <String, dynamic>{};
    booking['id'] = id;
    booking['order_id'] = orderId;
    booking['service_id'] = serviceId;
    booking['service_title'] = serviceTitle;
    booking['tax_percentage'] = taxPercentage;
    booking['tax_amount'] = taxAmount;
    booking['price'] = price;
    booking['quantity'] = quantity;
    booking['sub_total'] = subTotal;
    booking['status'] = status;
    booking['tags'] = tags;
    booking['duration'] = duration;
    booking['category_id'] = categoryId;
    booking['rating'] = rating;
    booking['comment'] = comment;
    booking['images'] = image;
    return booking;
  }
}
