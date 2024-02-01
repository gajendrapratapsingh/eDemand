// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserDetailsModel {
  String? id;
  String? username;
  String? phone;
  String? countryCode;
  String? email;
  String? fcmId;
  String? image;
  String? latitude;
  String? longitude;
  String? cityId;

  UserDetailsModel(
      {this.id,
      this.username,
      this.phone,
      this.countryCode,
      this.email,
      this.fcmId,
      this.image,
      this.latitude,
      this.longitude,
      this.cityId,});

  UserDetailsModel copyWith({
    final String? id,
    final String? username,
    final String? phone,
    final String? countryCode,
    final String? email,
    final String? fcmId,
    final String? image,
    final String? latitude,
    final String? longitude,
    final String? cityId,
  }) => UserDetailsModel(
        id: id ?? this.id,
        username: username ?? this.username,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        fcmId: fcmId ?? this.fcmId,
        image: image ?? this.image,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        cityId: cityId ?? this.cityId,
        countryCode: countryCode ?? this.countryCode,);

  Map<String, dynamic> toMap() => <String, dynamic>{
      "id": id,
      "username": username,
      "phone": phone,
      "email": email,
      "fcm_id": fcmId,
      "image": image,
      "latitude": latitude,
      "longitude": longitude,
      "city_id": cityId,
      "country_code": countryCode,
    };

  factory UserDetailsModel.fromMap(final Map<String, dynamic> map) => UserDetailsModel(
      id: map["id"] != null ? map["id"] as String : null,
      username: map["username"] != null ? map["username"] as String : null,
      phone: map["phone"] != null ? map["phone"] as String : null,
      countryCode: map["country_code"] != null ? map["country_code"] as String : null,
      email: map["email"] != null ? map["email"] as String : null,
      fcmId: map["fcm_id"] != null ? map["fcm_id"] as String : null,
      image: map["image"] != null ? map["image"] as String : null,
      latitude: map["latitude"] != null ? map['latitude'].toString() : null,
      longitude: map["longitude"] != null ? map['longitude'].toString() : null,
      cityId: map["city_id"] != null ? map["city_id"] as String : null,
    );

  UserDetailsModel fromMapCopyWith(final Map<String, dynamic> map) => UserDetailsModel(
      id: map["id"] != null ? map["id"] as String : id,
      username: map["username"] != null ? map["username"] as String : username,
      phone: map["phone"] != null ? map["phone"] as String : phone,
      countryCode: map["country_code"] != null ? map["country_code"] as String : countryCode,
      email: map["email"] != null ? map["email"] as String : email,
      fcmId: map["fcm_id"] != null ? map["fcm_id"] as String : fcmId,
      image: map["image"] != null ? map["image"] as String : image,
      latitude: map["latitude"] != null ? map["latitude"] as String : latitude,
      longitude: map["longitude"] != null ? map["longitude"] as String : longitude,
      cityId: map["city_id"] != null ? map["city_id"] as String : cityId,
    );

  String toJson() => json.encode(toMap());

  factory UserDetailsModel.fromJson(final String source) =>
      UserDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => "UserDetailsModel(id: $id, username: $username, phone: $phone, email: $email, fcm_id: $fcmId, image: $image, latitude: $latitude, longitude: $longitude, city_id: $cityId)";

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is UserDetailsModel &&
        other.id == id &&
        other.username == username &&
        other.phone == phone &&
        other.email == email &&
        other.fcmId == fcmId &&
        other.image == image &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityId == cityId;
  }

  @override
  int get hashCode => id.hashCode ^
        username.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        fcmId.hashCode ^
        image.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        cityId.hashCode;
}
