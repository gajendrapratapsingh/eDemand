class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.categoryImage,
    required this.backgroundDarkColor,
    required this.backgroundLightColor,
  });

  CategoryModel.fromJson(final Map<String?, dynamic> json) {
    id = json["id"] ?? '';
    name = json["name"] ?? '';
    slug = json["slug"] ?? '';
    categoryImage = json["category_image"] ?? '';
    backgroundLightColor = json['light_color'] ?? '';
    backgroundDarkColor = json['dark_color'] ?? '';
  }

  String? id;
  String? name;
  String? slug;
  String? categoryImage;
  String? backgroundDarkColor;
  String? backgroundLightColor;
}
