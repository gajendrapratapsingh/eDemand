// ignore_for_file: unused_local_variable

import 'package:e_demand/app/generalImports.dart';

class GetLocation {
  //if permission is allowed recently then onGranted method will invoke,
  //if permission is allowed already then allowed method will invoke,
  //if permission is rejected  then onRejected method will invoke,
  Future<void> requestPermission(
      {final Function(Position position)? onGranted,
      final Function()? onRejected,
      final Function(Position position)? allowed,
      final bool wantsToOpenAppSetting = false,}) async {
    //
     final LocationPermission checkPermission = await Geolocator.checkPermission();
    //
    if (checkPermission == LocationPermission.denied) {
      //
      final LocationPermission permission = await Geolocator.requestPermission();
      //

      if (permission == LocationPermission.deniedForever && wantsToOpenAppSetting) {
        //open app setting for permission
        //await AppSettings.openAppSettings();
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        //

        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );

        final Box userDetailBox = Hive.box(userDetailBoxKey);

        userDetailBox
           ..put(latitudeKey, position.latitude)
          ..put(longitudeKey, position.longitude);
        //
        final List<Placemark> placeMark = await GeocodingPlatform.instance
            .placemarkFromCoordinates(position.latitude, position.longitude);

        //get name from mark
        final String? name = placeMark[0].name;
        final subLocality = placeMark[0].subLocality;

         final String address = filterAddressString(
            "$name,$subLocality,${placeMark[0].locality},${placeMark[0].country}",);
        await userDetailBox.put(locationName, address);

        await Hive.box(userDetailBoxKey).put(longitudeKey, position.longitude);
        await Hive.box(userDetailBoxKey).put(latitudeKey, position.latitude);

        onGranted?.call(position);
      } else {
        await Hive.box(userDetailBoxKey).put(longitudeKey, "");
        await Hive.box(userDetailBoxKey).put(latitudeKey, "");
        onRejected?.call();
      }
    } else if (checkPermission == LocationPermission.always ||
        checkPermission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await Hive.box(userDetailBoxKey).put(longitudeKey, position.longitude);
      await Hive.box(userDetailBoxKey).put(latitudeKey, position.latitude);
      allowed?.call(position);
    }
  }

  Future getCurrentLocation() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final double latitude = position.latitude;
      final double longitude = position.longitude;

      final userDetail = Hive.box(userDetailBoxKey);
      userDetail
        ..put(latitudeKey,latitude)
        ..put(longitudeKey,longitude);

      final List<Placemark> placeMark = await placemarkFromCoordinates(latitude, longitude);

      await userDetail.putAll({
        latitudeKey: latitude.toString(),
        longitudeKey: longitude.toString(),
        cityKey: placeMark[0].name,
        postalCodeKey: placeMark[0].postalCode
      });
      return placeMark;
    }
  }

  Future<Position?> getPosition() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    }
    return null;
  }
}
