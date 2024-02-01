class Services {
  String? id;
  String? userId;
  String? categoryId;
  String? categoryName;
  String? partnerName;
  String? taxId;

  String? title;
  String? slug;
  String? description;
  String? longDescription;
  String? tags;
  String? imageOfTheService;
  List<String>? otherImagesOfTheService;
  List<String>? filesOfTheService;
  List<ServiceFaQs>? faqsOfTheService;
  String? price;
  String? discountedPrice;
  String? priceWithTax;
  String? originalPriceWithTax;
  String? taxAmount;
  String? numberOfMembersRequired;
  String? duration;
  String? rating;
  String? numberOfRatings;
  String? onSiteAllowed;
  String? maxQuantityAllowed;
  String? isPayLaterAllowed;
  String? status;
  String? cartQuantity;
  String? oneStar;
  String? twoStar;
  String? threeStar;
  String? fourStar;
  String? fiveStar;

  Services({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.partnerName,
    required this.taxId,
    required this.title,
    required this.slug,
    required this.description,
    required this.tags,
    required this.imageOfTheService,
    required this.price,
    required this.discountedPrice,
    required this.originalPriceWithTax,
    required this.taxAmount,
    required this.priceWithTax,
    required this.numberOfMembersRequired,
    required this.duration,
    required this.rating,
    required this.numberOfRatings,
    required this.onSiteAllowed,
    required this.maxQuantityAllowed,
    required this.isPayLaterAllowed,
    required this.status,
    required this.cartQuantity,
    required this.faqsOfTheService,
    required this.filesOfTheService,
    required this.longDescription,
    required this.otherImagesOfTheService,
    this.fiveStar,
    this.fourStar,
    this.threeStar,
    this.twoStar,
    this.oneStar,
  });

  Services.fromJson(final Map<String?, dynamic> json) {
    id = json["id"] ?? '';
    userId = json["userid"] ?? '';
    categoryId = json["category_id"] ?? '';
    categoryName = json["category_name"] ?? '';
    partnerName = json["partner_name"] ?? '';
    taxId = json["tax_id"] ?? '';
    title = json["title"] ?? '';
    slug = json["slug"] ?? '';
    description = json["description"] ?? '';
    // tags = json['tags'] ?? "";
    imageOfTheService = json["image_of_the_service"] ?? '';
    price = json["price"] ?? '';
    discountedPrice = json["discounted_price"] ?? '';
    originalPriceWithTax = json["original_price_with_tax"].toString();
    taxAmount = json["tax_value"] ?? '';
    priceWithTax = json["price_with_tax"].toString();
    numberOfMembersRequired = json["number_of_members_required"] ?? '';
    duration = json["duration"] ?? '0';
    rating = (json["average_rating"] ?? '0').toString();
    numberOfRatings = (json["total_ratings"] ?? '0').toString();
    onSiteAllowed = json["on_site_allowed"] ?? '0';
    maxQuantityAllowed = json["max_quantity_allowed"] ?? '0';
    isPayLaterAllowed = json["is_pay_later_allowed"] ?? '0';
    status = json["status"] ?? '';
    cartQuantity = json["in_cart_quantity"] != "" ? json["in_cart_quantity"] : "0";
    longDescription = json["long_description"] ?? '';
    oneStar = (json["rating_1"] ?? '0').toString();
    twoStar = (json["rating_2"] ?? '0').toString();
    threeStar = (json["rating_3"] ?? '0').toString();
    fourStar =( json["rating_4"] ?? '0').toString();
    fiveStar = (json["rating_5"] ?? '0').toString();
    if (json["faq"] != null && json['faq'] != "") {
      faqsOfTheService = <ServiceFaQs>[];
      json["faq"].forEach((final v) {
        faqsOfTheService!.add(ServiceFaQs.fromJson(v));
      });
    } else {
      faqsOfTheService = <ServiceFaQs>[];
    }
    if (json["other_images"] != null && json['other_images'] != "") {
      otherImagesOfTheService = <String>[];
      json["other_images"].forEach((final v) {
        otherImagesOfTheService!.add(v);
      });
    } else {
      otherImagesOfTheService = <String>[];
    }
    if (json["files"] != null && json["files"] != "") {
      filesOfTheService = <String>[];
      json["files"].forEach((final v) {
        filesOfTheService!.add(v);
      });
    } else {
      filesOfTheService = <String>[];
    }
  }
}

class ServiceFaQs {
  String? question;
  String? answer;

  ServiceFaQs({
    this.question,
    this.answer,
  });

  factory ServiceFaQs.fromJson(Map<String, dynamic> json) => ServiceFaQs(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}
