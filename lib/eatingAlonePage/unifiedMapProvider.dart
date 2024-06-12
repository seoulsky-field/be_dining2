import 'package:be_dining/eatingAlonePage/unifiedMarker_class.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'ListOfPlaces.dart';
import 'location_service.dart';
import 'location_class.dart';

class MapProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final LocationClass initLocation = LocationService.initLocation;


  final List<UnifiedMarker> facilityMarkers = [
    ...myFacilities.map((facility) => UnifiedMarker.fromData(facility))
  ];

  final List<UnifiedMarker> restaurantMarkers = [
    ...myRestaurants.map((restaurant) => UnifiedMarker.fromData(restaurant))
  ];

  MapProvider() {
    Future(setCurrentLocation);
  }

  LocationTrackingMode _trackingMode = LocationTrackingMode.None;

  LocationTrackingMode get trackingMode => _trackingMode;

  set trackingMode(LocationTrackingMode m) => throw "error";

  Future<void> setCurrentLocation() async {
    if (await _locationService.canGetCurrentLocation()) {
      _trackingMode = LocationTrackingMode.Follow;
      notifyListeners();
    }
  }

  void onTapMarker(String uid) {
    notifyListeners();
  }


  List<UnifiedMarker> getMarkersByLevel(int level) {
    return restaurantMarkers.where((marker) {
      if (marker.data is Restaurant) {
        return (marker.data as Restaurant).level == level;
      }
      return false;
    }).toList();
  }

}