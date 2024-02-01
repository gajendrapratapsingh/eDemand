class Providers {
  Providers({
    this.id,
    this.providerId,
    this.companyName,
    this.partnerName,
    this.image,
    this.advanceBookingDays,
    this.numberOfMembers,
    this.ratings,
    this.numberOfRatings,
    this.visitingCharge,
    this.isAvailableNow,
    this.about,
    this.address,
    this.fiveStar,
    this.fourStar,
    this.threeStar,
    this.twoStar,
    this.oneStar,
    this.isBookmark,
    this.bannerImage,
    this.sundayIsOpen,
    this.sundayOpeningTime,
    this.sundayClosingTime,
    this.saturdayIsOpen,
    this.saturdayOpeningTime,
    this.saturdayClosingTime,
    this.fridayIsOpen,
    this.fridayOpeningTime,
    this.fridayClosingTime,
    this.thursdayIsOpen,
    this.thursdayOpeningTime,
    this.thursdayClosingTime,
    this.wednesdayIsOpen,
    this.wednesdayOpeningTime,
    this.wednesdayClosingTime,
    this.tuesdayIsOpen,
    this.tuesdayOpeningTime,
    this.tuesdayClosingTime,
    this.mondayIsOpen,
    this.mondayOpeningTime,
    this.mondayClosingTime,
    this.businessDayInfo,
    this.otherImagesOfTheService,
    this.longDescription,
    this.latitude,
    this.longitude,
    this.isAvailableAtLocation,
    this.isAtStoreAvailable,
    this.isAtDoorstepAvailable,
  });

  Providers.fromJson(final Map<String?, dynamic> json) {
    id = json["id"] ?? "0";
    providerId = json["partner_id"] ?? "0";
    companyName = json["company_name"] ?? "";
    partnerName = json["partner_name"] ?? "";
    image = json["image"] ?? "";
    about = json["about"] ?? "";
    address = json["address"] ?? "";
    advanceBookingDays = json["advance_booking_days"];
    numberOfMembers = json["number_of_members"];
    ratings = double.parse(json["ratings"] ?? '0.0').toStringAsFixed(1);
    numberOfRatings = json["number_of_ratings"] ?? '0';
    visitingCharge = json["visiting_charges"] ?? '0';
    isAvailableNow = json["is_available_now"] ?? false;
    oneStar = json["1_star"] ?? '0';
    twoStar = json["2_star"] ?? '0';
    threeStar = json["3_star"] ?? '0';
    fourStar = json["4_star"] ?? '0';
    fiveStar = json["5_star"] ?? '0';
    isBookmark = json["is_favorite"];
    bannerImage = json["banner_image"];
    sundayIsOpen = json["sunday_is_open"];
    sundayOpeningTime = json["sunday_opening_time"];
    sundayClosingTime = json["sunday_closing_time"];
    saturdayIsOpen = json["saturday_is_open"];
    saturdayOpeningTime = json["saturday_opening_time"];
    saturdayClosingTime = json["saturday_closing_time"];
    fridayIsOpen = json["friday_is_open"];
    fridayOpeningTime = json["friday_opening_time"];
    fridayClosingTime = json["friday_closing_time"];
    thursdayIsOpen = json["thursday_is_open"];
    thursdayOpeningTime = json["thursday_opening_time"];
    thursdayClosingTime = json["thursday_closing_time"];
    wednesdayIsOpen = json["wednesday_is_open"];
    wednesdayOpeningTime = json["wednesday_opening_time"];
    wednesdayClosingTime = json["wednesday_closing_time"];
    tuesdayIsOpen = json["tuesday_is_open"];
    tuesdayOpeningTime = json["tuesday_opening_time"];
    tuesdayClosingTime = json["tuesday_closing_time"];
    mondayIsOpen = json["monday_is_open"];
    mondayOpeningTime = json["monday_opening_time"];
    mondayClosingTime = json["monday_closing_time"];
    longDescription = json["long_description"] ?? '';
    latitude = json["latitude"];
    longitude = json["longitude"];
    isAtDoorstepAvailable = json["at_doorstep"];
    isAtStoreAvailable = json["at_store"];
    isAvailableAtLocation = json["is_Available_at_location"] ?? "0";
    if (json["other_images"] != null) {
      otherImagesOfTheService = <String>[];
      json["other_images"].forEach((final v) {
        otherImagesOfTheService!.add(v);
      });
    } else {
      otherImagesOfTheService = <String>[];
    }
    businessDayInfo = [
      {
        "day": "monday",
        "isOpen": mondayIsOpen,
        "openingTime": mondayOpeningTime,
        "closingTime": mondayClosingTime,
      },
      {
        "day": "tuesday",
        "isOpen": tuesdayIsOpen,
        "openingTime": tuesdayOpeningTime,
        "closingTime": tuesdayClosingTime,
      },
      {
        "day": "wednesday",
        "isOpen": wednesdayIsOpen,
        "openingTime": wednesdayOpeningTime,
        "closingTime": wednesdayClosingTime,
      },
      {
        "day": "thursday",
        "isOpen": thursdayIsOpen,
        "openingTime": thursdayOpeningTime,
        "closingTime": thursdayClosingTime,
      },
      {
        "day": "friday",
        "isOpen": fridayIsOpen,
        "openingTime": fridayOpeningTime,
        "closingTime": fridayClosingTime,
      },
      {
        "day": "saturday",
        "isOpen": saturdayIsOpen,
        "openingTime": saturdayOpeningTime,
        "closingTime": saturdayClosingTime,
      },
      {
        "day": "sunday",
        "isOpen": sundayIsOpen,
        "openingTime": sundayOpeningTime,
        "closingTime": sundayClosingTime,
      },
    ].map((e) => DayInfo.fromMap(e)).toList();
  }

  String? id;
  String? providerId;
  String? companyName;
  String? partnerName;
  String? image;
  String? advanceBookingDays;
  String? numberOfMembers;
  String? ratings;
  String? numberOfRatings;
  String? visitingCharge;
  String? about;
  String? address;
  bool? isAvailableNow;
  String? oneStar;
  String? twoStar;
  String? threeStar;
  String? fourStar;
  String? fiveStar;
  String? isBookmark;
  String? bannerImage;
  String? sundayIsOpen;
  String? sundayOpeningTime;
  String? sundayClosingTime;
  String? saturdayIsOpen;
  String? saturdayOpeningTime;
  String? saturdayClosingTime;
  String? fridayIsOpen;
  String? fridayOpeningTime;
  String? fridayClosingTime;
  String? thursdayIsOpen;
  String? thursdayOpeningTime;
  String? thursdayClosingTime;
  String? wednesdayIsOpen;
  String? wednesdayOpeningTime;
  String? wednesdayClosingTime;
  String? tuesdayIsOpen;
  String? tuesdayOpeningTime;
  String? tuesdayClosingTime;
  String? mondayIsOpen;
  String? mondayOpeningTime;
  String? mondayClosingTime;
  List<String>? otherImagesOfTheService;
  List<DayInfo>? businessDayInfo;
  String? longDescription;
  String? latitude;
  String? longitude;
  String? isAvailableAtLocation;
  String? isAtStoreAvailable;
  String? isAtDoorstepAvailable;
}

class DayInfo {
  String? day;
  String? isOpen;
  String? openingTime;
  String? closingTime;

  DayInfo({
    this.day,
    this.isOpen,
    this.openingTime,
    this.closingTime,
  });

  factory DayInfo.fromMap(Map<String, dynamic> json) => DayInfo(
        day: json["day"],
        isOpen: json["isOpen"],
        openingTime: json["openingTime"],
        closingTime: json["closingTime"],
      );
}
