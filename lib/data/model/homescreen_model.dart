import 'package:e_demand/data/model/category_model.dart';
import 'package:e_demand/data/model/section_model.dart';
import 'package:e_demand/data/model/slider_images_model.dart';

class HomeScreenModel {

  HomeScreenModel(this.sections, this.category, this.sliders);

  HomeScreenModel.fromJson(final Map<String?, dynamic> json) {

    if (json["sections"] != null) {
      sections = <Sections>[];
      json["sections"].forEach((final v) {

        sections!.add(Sections.fromJson(v));
      });
    }
    if (json["sliders"] != null) {
      sliders = <SliderImages>[];
      json["sliders"].forEach((final v) {
        sliders!.add(SliderImages.fromJson(v));
      });
    }
    if (json["categories"] != null) {
      category = <CategoryModel>[];
      json["categories"].forEach((final v) {
        category!.add(CategoryModel.fromJson(v));
      });
    }
  }
  List<Sections>? sections;
  List<CategoryModel>? category;
  List<SliderImages>? sliders;
}
