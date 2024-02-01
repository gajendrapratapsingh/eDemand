class SliderImages {
  SliderImages({
    required this.id,
    required this.type,
    required this.typeId,
    required this.sliderImage,
    required this.categoryName,
    required this.providerName,
  });

  SliderImages.fromJson(final Map<String?, dynamic> json) {
    id = json["id"] ?? '';
    type = json["type"] ?? '';
    typeId = json["type_id"] ?? '';
    sliderImage = json["slider_image"] ?? '';
    categoryName = json["category_name"] ?? '';
    providerName = json["provider_name"] ?? '';
  }

  String? id;
  String? type;
  String? typeId;
  String? sliderImage;
  String? categoryName;
  String? providerName;
}
