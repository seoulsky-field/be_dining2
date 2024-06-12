import 'package:flutter_naver_map/flutter_naver_map.dart' as naver;
import 'package:naver_map_plugin/naver_map_plugin.dart';

import 'ListOfPlaces.dart';

class UnifiedMarker extends Marker {
  final dynamic data; // Restaurant 또는 Facilities가 될 수 있음
  final String markerImage;

  UnifiedMarker({required this.data, required this.markerImage, required super.position, super.width = 30, super.height = 30})
      : super(
      markerId: data.uid,
      captionText: data is Restaurant ? data.storeName : data.placeName);

  factory UnifiedMarker.fromData(dynamic data) {
    String markerImage = data is Restaurant ? data.markerImage : (data as Facilities).markerImage;
    LatLng position = data is Restaurant ? data.location : (data as Facilities).location;
    return UnifiedMarker(data: data, markerImage: markerImage, position: position);
  }

  Future<void> createImage() async {
    icon = await OverlayImage.fromAssetImage(assetName: markerImage);
  }

  void setOnMarkerTab(void Function(UnifiedMarker?, Map<String, int?>) callBack) {
    onMarkerTab = callBack as OnMarkerTab?;
  }

}