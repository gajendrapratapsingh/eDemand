import 'package:e_demand/app/generalImports.dart';

class SectionRepository {
  //
  ///This method is used to fetch sectionList
  Future<Map<String, dynamic>> fetchSectionList({required final bool isAuthTokenRequired}) async {
    try {
      final Map<String, dynamic> parameters = <String, dynamic>{};

      final  result = await Api.post(
          parameter: parameters, url: Api.getSections, useAuthToken: isAuthTokenRequired,);

      return {
        "sectionList": (result['data'] as List)
            .map((final sectionData) => Sections.fromJson(Map.from(sectionData)))
            .toList()
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
