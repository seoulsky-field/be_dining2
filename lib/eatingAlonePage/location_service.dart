import 'package:geolocator/geolocator.dart';

import 'location_class.dart';

class LocationService {
  // init location 단국대로 설정
  static const LocationClass initLocation = LocationClass(latitude: 37.321838803127086, longitude: 127.12488412857056);


  Future<LocationPermission> hasLocationPermission() async => await Geolocator.checkPermission();

  Future<bool> isLocationEnabled() async => await Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> requestLocation() async => await Geolocator.requestPermission();

  Future<LocationClass> currentLocation() async {
    final Position position = await Geolocator.getCurrentPosition();
    return LocationClass(latitude: position.latitude, longitude: position.longitude);
  }

  Future<bool> canGetCurrentLocation() async {
    final LocationPermission permission = await hasLocationPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final bool enabled = await isLocationEnabled();
      if (enabled) return true;
    }
    return false;
  }
}