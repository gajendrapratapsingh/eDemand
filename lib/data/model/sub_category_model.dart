class SubCategory {

  SubCategory({
    this.id,
    this.name,
    this.slug,
    this.categoryImage,
    this.darkBackgroundColor,
    this.lightBackgroundColor,
  });

  SubCategory.fromJson(final Map<String, dynamic> json)
      : id = json["id"] ?? '',
        name = json["name"] ?? '',
        slug = json["slug"] ?? '',
        darkBackgroundColor = json["dark_color"] ?? '',
        lightBackgroundColor = json["light_color"] ?? '',
        categoryImage = json["category_image"] ?? '';
  final String? id;
  final String? name;
  final String? slug;
  final String? categoryImage;
  final String? darkBackgroundColor;
  final String? lightBackgroundColor;
}
