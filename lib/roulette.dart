import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RecRoulette(),
    );
  }
}

class RecRoulette extends StatefulWidget {
  const RecRoulette({Key? key}) : super(key: key);

  @override
  State<RecRoulette> createState() => _RecRouletteState();
}

class _RecRouletteState extends State<RecRoulette> {
  final List<String> _recMenu = [
    "피자",
    "햄버거",
    "파스타",
    "국밥",
    "마라탕",
    "샐러드",
    "덮밥",
    "라멘",
    "떡볶이",
    "카레",
    "마라탕",
    "우동",
    "치킨",
    "제육볶음",
    "돈까스",
    "칼국수",
    "김치짜글이",
    "소바",
    "비빔밥",
    "수육"
  ];
  final List<String> _recRestaurant = [
    "호식당",
    "손가네칼국수",
    "한솥도시락",
    "투고박스누들",
    "홍콩반점0410",
    "파스타하우스",
    "아리가또맘마",
    "고래심줄",
    "선영이네김치짜글이",
    "퍼스트네팔레스토랑",
    "고씨네",
    "미소야",
    "백소정",
    "해피덮",
    "구들장흑도야지",
    "권선생s싱싱한연어바삭한새우",
    "더진국 수육국밥",
    "맘스터치",
    "이삭토스트",
    "신정면"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const WidgetSpan(
                      child: Icon(Icons.star_border, size: 35, color: Color(0xffbf2142)),
                    ),
                  ),
                ), const SizedBox(height: 5),
                SizedBox(
                    height: 30,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        text: '메뉴 추천',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffbf2142),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ),const SizedBox(height: 5),
                const SizedBox(
                  height: 20,
                  child: Text(
                      "아래로 슬라이드하여 랜덤으로 추천받아 보세요!",
                      style: TextStyle(
                        fontSize: 13,
                      )
                  ),
                ), const SizedBox(height: 40),
                SizedBox(
                    height: 20,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        text: '오늘 뭐 먹지?',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ), const SizedBox(height: 20),
                SizedBox(
                    height: 120,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: 0
                        ),
                        looping: true,
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {},
                        children: List<Widget>.generate(20, (index) {
                          return Text(
                            _recMenu[index],
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          );
                        }),
                      ),
                    )
                ), const SizedBox(height: 40),
                SizedBox(
                    height: 20,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        text: '학교 앞 식당 추천',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                ), const SizedBox(height: 20),
                SizedBox(
                    height: 120,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          pickerTextStyle: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                            initialItem: 0
                        ),
                        looping: true,
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {},
                        children: List<Widget>.generate(20, (index) {
                          return Text(
                            _recRestaurant[index],
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          );
                        }),
                      ),
                    )
                ), const SizedBox(height: 40),
              ],
            ),
          ),
        )
    );
  }
}