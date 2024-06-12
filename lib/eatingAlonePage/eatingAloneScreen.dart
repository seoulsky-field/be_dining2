import 'dart:async';
import 'package:be_dining/eatingAlonePage/location_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart' as naver;
import 'package:naver_map_plugin/naver_map_plugin.dart'
    show
        CameraPosition,
        CameraUpdate,
        LatLng,
        LocationTrackingMode,
        MapType,
        Marker,
        NaverMap,
        NaverMapController,
        PathOverlay,
        PathOverlayId;
import 'unifiedMapProvider.dart';
import 'unifiedMarker_class.dart';
import 'ListOfPlaces.dart';
import 'package:geolocator/geolocator.dart';

class EatingAlonePage2 extends StatefulWidget {
  const EatingAlonePage2({super.key, required this.mapProvider});

  final MapProvider mapProvider;

  @override
  State<EatingAlonePage2> createState() => _EatingAlonePageState();
}

class _EatingAlonePageState extends State<EatingAlonePage2>
    with SingleTickerProviderStateMixin {
  double height = 500;
  Completer<NaverMapController> _controller = Completer();
  final MapType _mapType = MapType.Basic;
  late TabController _tabController;
  int _selectedLevel = 1;
  // 레벨별로 걸러서 마커 표시
  List<UnifiedMarker> _currentMarkers = []; // 현재 표시할 마커 리스트

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 탭 컨트롤러 설정
    _tabController.addListener(_onTabChanged); // 탭 변경 리스너 추가

    // 모든 마커를 생성하고 설정하는 비동기 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // 위젯이 마운트되지 않은 경우 종료

      // 시설 마커에 대한 이미지 생성 및 탭 이벤트 설정
      widget.mapProvider.facilityMarkers.forEach((UnifiedMarker marker) {
        marker.createImage();
        marker.setOnMarkerTab((Marker? marker, Map<String, int?> iconSize) async {
          // 마커 탭 콜백 로직 (여기서는 비어 있음)
        });
      });

      // 레스토랑 마커에 대한 이미지 생성 및 탭 이벤트 설정
      widget.mapProvider.restaurantMarkers.forEach((UnifiedMarker marker) {
        marker.createImage();
        marker.setOnMarkerTab((Marker? marker, Map<String, int?> iconSize) async {
          // 마커 탭 콜백 로직 (여기서는 비어 있음)
        });
      });

      _updateMarkers(); // 초기 마커 설정
    });
  }

  // 탭 변경 시 호출되는 메서드
  void _onTabChanged() {
    setState(() {
      _selectedLevel = _tabController.index + 1; // 선택된 레벨을 업데이트
      _updateMarkers(); // 마커 업데이트 호출
    });
  }

  // 마커를 업데이트하는 메서드
  Future<void> _updateMarkers() async {
    List<UnifiedMarker> filteredMarkers = widget.mapProvider.getMarkersByLevel(_selectedLevel);
    await Future.wait(filteredMarkers.map((marker) => marker.createImage()));

    setState(() {
      _currentMarkers = [
        ...widget.mapProvider.facilityMarkers, // 항상 표시되는 시설 마커
        ...filteredMarkers // 필터링된 레스토랑 마커
      ];
    });
  }

  // 레벨에 따라 레스토랑을 필터링하는 메서드
  List<Restaurant> _filterRestaurants(int level) {
    return myRestaurants.where((restaurant) => restaurant.level == level).toList();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged); // 탭 변경 리스너 제거
    _tabController.dispose(); // 탭 컨트롤러 해제
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // height = MediaQuery.of(context).size.height - 300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 60.0), // Adjust the bottom padding
                          child: NaverMap(
                          zoomGestureEnable: true,
                          initLocationTrackingMode:
                              widget.mapProvider.trackingMode,
                          scrollGestureEnable: true,
                          initialCameraPosition: CameraPosition(
                              target: widget.mapProvider.initLocation),
                          locationButtonEnable: true,
                          onMapCreated: (NaverMapController ct) {
                            _controller = _controller;
                          },
                            markers: _currentMarkers.cast<Marker>().toList(),
                          // markers: widget.mapProvider.myMarkers,
                          // markers: widget.mapProvider.myMarkers
                          //     .cast<Marker>()
                          //     .toList(),
                          //   markers: widget.mapProvider.getMarkersByLevel(_selectedLevel)
                          //       .cast<Marker>()
                          //       .toList(),
                        ),
    ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              expandedHeight: height,
              pinned: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: Colors.transparent, // 선택된 탭 아래 검은 줄 제거
                        ),
                        indicatorColor: Colors.transparent,
                        tabs: [
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: _tabController.index == 0
                                    ? Color(0xffBF2142)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Color(0xffD6D6D6)),
                              ),
                              child: Text('혼밥 LV.1'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: _tabController.index == 1
                                    ? Color(0xffBF2142)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Color(0xffD6D6D6)),
                              ),
                              child: Text('혼밥 LV.2'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                color: _tabController.index == 2
                                    ? Color(0xffBF2142)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Color(0xffD6D6D6)),
                              ),
                              child: Text('혼밥 LV.3'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15), // 탭과 "추천 음식점" 사이 간격
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        // 텍스트와 리스트 정렬
                        child: Text(
                          '추천 음식점',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // "추천 음식점"과 목록 사이 간격
                    ],
                  ),
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              RestaurantList(restaurants: _filterRestaurants(1)),
              RestaurantList(restaurants: _filterRestaurants(2)),
              RestaurantList(restaurants: _filterRestaurants(3)),
            ],
          ),
        ),
    );
  }

  void onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }
}

class RestaurantList extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantList({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            RestaurantListItem(restaurant: restaurants[index]),
          ],
        );
      },
    );
  }
}

class RestaurantListItem extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantListItem({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        title: Text(
          restaurant.storeName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.category,
              style: TextStyle(
                color: Color(0xff848484),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.red, size: 16),
                SizedBox(width: 4),
                Text(
                  restaurant.rate.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
