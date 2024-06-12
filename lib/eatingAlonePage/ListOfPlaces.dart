
import 'unifiedMarker_class.dart';
import 'location_class.dart';

class Restaurant {

  final String uid;
  final String storeName;
  final String address;
  final String category;
  final LocationClass location;
  final String markerImage = "assets/images/marker.png";
  final double rate;
  final int level;

  Restaurant({
    required this.uid,
    required this.storeName,
    required this.address,
    required this.category,
    required this.location,
    required this.rate,
    required this.level
  });

  static List<UnifiedMarker> myMarkers(){
    List<UnifiedMarker> list = [];
    for (var st in myRestaurants) {
      list.add(UnifiedMarker.fromData(st));
    }
    return list;
  }
}

final List<Restaurant> myRestaurants = [
  Restaurant(
    uid: "1",
    storeName: "해피덮",
    address: "경기도 용인시 수지구 죽전로 168번길 31-1",
    category: "한식",
    location: LocationClass(latitude: 37.32426399233429, longitude: 127.12597578763962),
    rate: 4.58,
    level: 1,
  ),
  Restaurant(
    uid: "2",
    storeName: "맘스터치 BEEF",
    address: "경기도 용인시 수지구 죽전로 144번길 12-1",
    category: "햄버거",
    location: LocationClass(latitude: 37.322847708408155, longitude: 127.1241170167923),
    rate: 4.5,
    level: 1,
  ),
  Restaurant(
    uid: "3",
    storeName: "이삭토스트",
    address: "경기도 용인시 수지구 현암로 145 샤르망테마프라자",
    category: "토스트",
    location: LocationClass(latitude: 37.32399315948335, longitude: 127.12436462092816),
    rate: 4.62,
    level: 1,
  ),
  Restaurant(
    uid: "4",
    storeName: "한솥도시락",
    address: "경기도 용인시 수지구 죽전로 140 103",
    category: "도시락, 컵밥",
    location: LocationClass(latitude: 37.323674232768, longitude: 127.1232157945633),
    rate: 4.4,
    level: 1,
  ),
  Restaurant(
    uid: "5",
    storeName: "구들장 흑도야지",
    address: "경기도 용인시 수지구 죽전로 176 죽전프라자 2층",
    category: "한식뷔페",
    location: LocationClass(latitude: 37.32620707338393, longitude: 127.12506651878357),
    rate: 4.58,
    level: 1,
  ),
  Restaurant(
    uid: "6",
    storeName: "미소야",
    address: "경기도 용인시 수지구 죽전로 144번길 4-1",
    category: "돈가스",
    location: LocationClass(latitude: 37.32342840937592, longitude: 127.1237113326788),
    rate: 4.43,
    level: 2,
  ),
  Restaurant(
    uid: "7",
    storeName: "손가네 칼국수",
    address: "경기도 용인시 수지구 죽전로 140 104호",
    category: "칼국수, 만두",
    location: LocationClass(latitude: 37.323635179663015, longitude: 127.12315936000091),
    rate: 4.54,
    level: 2,
  ),
  Restaurant(
    uid: "8",
    storeName: "신정면",
    address: "경기도 용인시 수지구 죽전로 168번길 7 승은프라자 107호",
    category: "우동, 소바",
    location: LocationClass(latitude: 37.32554834870965, longitude: 127.12521552719585),
    rate: 4.38,
    level: 2,
  ),
  Restaurant(
    uid: "9",
    storeName: "백소정",
    address: "경기도 용인시 수지구 죽전로 150 1층 101호",
    category: "일식당",
    location: LocationClass(latitude: 37.32395704545037, longitude: 127.12442567033338),
    rate: 4.61,
    level: 2,
  ),
  Restaurant(
    uid: "10",
    storeName: "더진국 수육국밥",
    address: "경기도 용인시 수지구 죽전로 168번길 20번길 단대성지프라자",
    category: "국밥",
    location: LocationClass(latitude: 37.32426122940648, longitude: 127.1248608521544),
    rate: 4.15,
    level: 2,
  ),
  Restaurant(
    uid: "11",
    storeName: "호식당",
    address: "경기도 용인시 수지구 죽전로144번길 12-1",
    category: "일식당",
    location: LocationClass(latitude: 37.32360277876295, longitude: 127.12323054671288),
    rate: 4.51,
    level: 3,
  ),
  Restaurant(
    uid: "12",
    storeName: "고씨네",
    address: "경기도 용인시 수지구 죽전로144번길 16-8",
    category: "카레",
    location: LocationClass(latitude: 37.322534160014534, longitude: 127.12396144866943),
    rate: 4.37,
    level: 3,
  ),
  Restaurant(
    uid: "13",
    storeName: "퍼스트네팔레스토랑",
    address: "경기도 용인시 수지구 죽전로144번길 12-7",
    category: "인도음식",
    location: LocationClass(latitude: 37.322726028027596, longitude: 127.12385190382714),
    rate: 4.63,
    level: 3,
  ),
  Restaurant(
    uid: "14",
    storeName: "신쭈꾸미",
    address: "경기도 용인시 수지구 죽전로144번길 15-7",
    category: "쭈꾸미",
    location: LocationClass(latitude: 37.322534160014534, longitude: 127.12396144866943),
    rate: 4.43,
    level: 3,
  ),
  Restaurant(
    uid: "15",
    storeName: "내가찜한닭",
    address: "경기도 용인시 수지구 죽전로168번길 21",
    category: "카레",
    location: LocationClass(latitude: 37.32425841722126, longitude: 127.12538884764476 ),
    rate: 4.51,
    level: 3,
  ),
];

class Facilities {

  final String uid;
  final String placeName;
  final String extraInfo;
  final LocationClass location;
  final String markerImage = "assets/images/fmarker.png";


  Facilities({
    required this.uid,
    required this.placeName,
    required this.extraInfo,
    required this.location,

  });


  static List<UnifiedMarker> myMarkers(){
    List<UnifiedMarker> list = [];
    for (var st in myFacilities) {
      list.add(UnifiedMarker.fromData(st));
    }
    return list;
  }
}

final List<Facilities> myFacilities = [
  Facilities(
  uid: "1",
  placeName: "ICT관 5층 과 휴게실",
  extraInfo: "엘레베이터 앞, 학생회실 옆",
  location: LocationClass(latitude: 37.32286174142577, longitude: 127.12756684254562),
),
  Facilities(
    uid: "2",
    placeName: "ICT관 1층 ",
    extraInfo: "좌측 건물 입구 바로 옆",
    location: LocationClass(latitude: 37.322625827606075, longitude: 127.12700232770874),
  ),
  Facilities(
    uid: "3",
    placeName: "미디어관 5층 휴게실",
    extraInfo: "엘레베이터 옆, 516호 앞",
    location: LocationClass(latitude:  37.32218834232741, longitude: 127.12745288174999),
  ),
  Facilities(
    uid: "4",
    placeName: "도서관 창업 카페",
    extraInfo: "GS25, cafe 1894 앞",
    location: LocationClass(latitude: 37.321134551460766, longitude: 127.12706469032214),
  ),
  Facilities(
    uid: "5",
    placeName: "법학관 야외 테이블",
    extraInfo: "cafe 르호봇 앞",
    location: LocationClass(latitude:  37.32098825913355, longitude:  127.1290303458688),
  ),
  Facilities(
    uid: "6",
    placeName: "상경관 1층 테이블",
    extraInfo: "GS25 앞",
    location: LocationClass(latitude:  37.322450046652385, longitude:  127.1290303458688),
  ),
  Facilities(
    uid: "7",
    placeName: "3공학관 5층 창업 카페",
    extraInfo: "엘레베이터 옆",
    location: LocationClass(latitude:  37.320292335319984, longitude:  127.12915695025788),
  ),
  Facilities(
    uid: "8",
    placeName: "웅비홀 휴게실",
    extraInfo: "CU 옆",
    location: LocationClass(latitude:  37.3158840467737, longitude:  127.12681612405252),
  ),
];