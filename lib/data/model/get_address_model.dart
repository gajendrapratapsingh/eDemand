// ignore_for_file: public_member_api_docs, sort_constructors_first
class GetAddressModel {
  String? id;
  String? type;
  String? address;
  String? cityName;
  String? area;
  String? mobile;
  String? alternateMobile;
  String? pincode;
  String? cityId;
  String? landmark;
  String? state;
  String? country;
  String? lattitude;
  String? longitude;
  String? isDefault;
  String? createdAt;

  GetAddressModel(
      {this.id,
      this.type,
      this.address,
      this.cityName,
      this.area,
      this.mobile,
      this.alternateMobile,
      this.pincode,
      this.cityId,
      this.landmark,
      this.state,
      this.country,
      this.lattitude,
      this.longitude,
      this.isDefault,
      this.createdAt,});

  GetAddressModel.fromJson(final Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    address = json['address'];
    cityName = json['city_name'];
    area = json['area'];
    mobile = json['mobile'];
    alternateMobile = json['alternate_mobile'].toString();
    pincode = json['pincode'];
    cityId = json['city_id'];
    landmark = json['landmark'];
    state = json['state'];
    country = json['country'];
    lattitude = json['lattitude'];
    longitude = json['longitude'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['address'] = address;
    data['city_name'] = cityName;
    data['area'] = area;
    data['mobile'] = mobile;
    data['alternate_mobile'] = alternateMobile;
    data['pincode'] = pincode;
    data['city_id'] = cityId;
    data['landmark'] = landmark;
    data['state'] = state;
    data['country'] = country;
    data['lattitude'] = lattitude;
    data['longitude'] = longitude;
    data['is_default'] = isDefault;
    data['created_at'] = createdAt;
    return data;
  }

  @override
  String toString() => "GetAddressModel(id: $id, type: $type, address: $address, cityName: $cityName, area: $area, mobile: $mobile, alternateMobile: $alternateMobile, pincode: $pincode, cityId: $cityId, landmark: $landmark, state: $state, country: $country, lattitude: $lattitude, longitude: $longitude, isDefault: $isDefault, createdAt: $createdAt)";
}
