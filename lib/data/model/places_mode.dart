//Model is created to parse data of Place API to search location

class PlacesModel {

  PlacesModel({this.predictions, this.status});

  PlacesModel.fromJson(final Map<String, dynamic> json) {
    if (json["predictions"] != null) {
      predictions = [];
      json["predictions"].forEach((final v) {
        predictions!.add(Prediction.fromJson(v));
      });
    }
    status = json["status"];
  }
  List<Prediction>? predictions;
  String? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (predictions != null) {
      data['predictions'] = predictions!.map((final v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Prediction {

  Prediction(
      {this.description,
      this.id,
      this.matchedSubstrings,
      this.placeId,
      this.reference,
      this.structuredFormatting,
      this.terms,
      this.types,
      this.lat,
      this.lng,});

  Prediction.fromJson(final Map<String, dynamic> json) {
    description = json["description"];
    id = json["id"];
    if (json["matched_substrings"] != null) {
      matchedSubstrings = [];
      json["matched_substrings"].forEach((final v) {
        matchedSubstrings!.add(MatchedSubstrings.fromJson(v));
      });
    }
    placeId = json["place_id"];
    reference = json["reference"];
    structuredFormatting = json["structured_formatting"] != null
        ? StructuredFormatting.fromJson(json["structured_formatting"])
        : null;
    if (json["terms"] != null) {
      terms = [];
      json["terms"].forEach((final v) {
        terms!.add(Terms.fromJson(v));
      });
    }
    types = json["types"].cast<String>();
    lat = json["lat"];
    lng = json["lng"];
  }
  String? description;
  String? id;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Terms>? terms;
  List<String>? types;
  String? lat;
  String? lng;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    if (matchedSubstrings != null) {
      data['matched_substrings'] =
          matchedSubstrings!.map((final v) => v.toJson()).toList();
    }
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (structuredFormatting != null) {
      data['structured_formatting'] = structuredFormatting!.toJson();
    }
    if (terms != null) {
      data['terms'] = terms!.map((final v) => v.toJson()).toList();
    }
    data['types'] = types;
    data['lat'] = lat;
    data['lng'] = lng;

    return data;
  }
}

class MatchedSubstrings {

  MatchedSubstrings({this.length, this.offset});

  MatchedSubstrings.fromJson(final Map<String, dynamic> json) {
    length = json["length"];
    offset = json["offset"];
  }
  int? length;
  int? offset;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['offset'] = offset;
    return data;
  }
}

class StructuredFormatting {

  StructuredFormatting({this.mainText, this.secondaryText});

  StructuredFormatting.fromJson(final Map<String, dynamic> json) {
    mainText = json["main_text"];

    secondaryText = json["secondary_text"];
  }
  String? mainText;

  String? secondaryText;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_text'] = mainText;
    data['secondary_text'] = secondaryText;
    return data;
  }
}

class Terms {

  Terms({this.offset, this.value});

  Terms.fromJson(final Map<String, dynamic> json) {
    offset = json["offset"];
    value = json["value"];
  }
  int? offset;
  String? value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['value'] = value;
    return data;
  }
}
