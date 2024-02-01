class Reviews {
  Reviews({
     this.id,
     this.userId,
     this.partnerName,
     this.rating,
     this.providerId,
     this.userName,
     this.profileImage,
     this.serviceId,
     this.comment,
     this.images,
     this.ratedOn,
     this.rateUpdatedOn,
  });

  Reviews.fromJson(final Map<String?, dynamic> json) {
    id = json["id"] ?? '';
    userId = json["user_id"] ?? '';
    providerId = json["partner_id"] ?? '';
    partnerName = json["partner_name"] ?? '';
    rating = json["rating"] ?? '';
    userName = json["user_name"] ?? '';
    profileImage = json["profile_image"] ?? '';
    serviceId = json["service_id"] ?? '';
    comment = json["comment"] ?? '';
    images = json["images"] ?? '';
    ratedOn = json["rated_on"] ?? '';
    rateUpdatedOn = json["rate_updated_on"] ?? '';
  }

  String? id;
  String? userId;
  String? providerId;
  String? partnerName;
  String? userName;
  String? profileImage;
  String? serviceId;
  String? rating;
  String? comment;
  List<dynamic>? images;
  String? ratedOn;
  String? rateUpdatedOn;
}
