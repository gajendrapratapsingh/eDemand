import 'package:e_demand/app/generalImports.dart';

class CategoryRepository {
  //
  ///This method is used to fetch categories
  Future fetchCategory({final int? limitOfAPIData, final int? offset}) async {
    try {
      final Map<String, dynamic> parameters = <String, dynamic>{
        Api.longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString(),
        Api.latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
        // Api.limit: limitOfAPIData,
        //Api.offset: offset ?? 0,
      };
      final  result =
          await Api.post(parameter: parameters, url: Api.getCategories, useAuthToken: false);

      return (result['data'] as List).map((final e) => CategoryModel.fromJson(Map.from(e))).toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
