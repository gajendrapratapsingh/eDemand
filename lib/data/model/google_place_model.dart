// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GooglePlaceModel {
  final String name;
  final String cityName;
  final String placeId;
  final String latitude;
  final String longitude;

  GooglePlaceModel({
    required this.name,
    required this.cityName,
    required this.placeId,
    required this.latitude,
    required this.longitude,
  });

  GooglePlaceModel copyWith({
    final String? name,
    final String? cityName,
    final String? placeId,
    final String? latitude,
    final String? longitude,
  }) => GooglePlaceModel(
      name: name ?? this.name,
      cityName: cityName ?? this.cityName,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );

  Map<String, dynamic> toMap() => <String, dynamic>{
      "name": name,
      "cityName": cityName,
      "placeId": placeId,
      "latitude": latitude,
      "longitude": longitude,
    };

  factory GooglePlaceModel.fromMap(final Map<String, dynamic> map) => GooglePlaceModel(
      name: map["name"] as String,
      cityName: map["cityName"] as String,
      placeId: map["placeId"] as String,
      latitude: map["latitude"] as String,
      longitude: map["longitude"] as String,
    );

  String toJson() => json.encode(toMap());

  factory GooglePlaceModel.fromJson(final String source) =>
      GooglePlaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => "GooglePlaceModel(name: $name, cityName: $cityName, placeId: $placeId, latitude: $latitude, longitude: $longitude)";

  @override
  bool operator ==(covariant final GooglePlaceModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.cityName == cityName &&
        other.placeId == placeId &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => name.hashCode ^
        cityName.hashCode ^
        placeId.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
}
