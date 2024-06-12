import 'package:be_dining/roulette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'eatingAlonePage/eatingAloneScreen.dart';
import 'eatingAlonePage/unifiedMapProvider.dart';

// import 'login.dart';
import 'logout.dart';

import 'package:be_dining/screens/serach_screen.dart';
import './screens/splash_screen.dart';
import './screens/board_screen.dart';
import './screens/auth_screen2.dart';
import './screens/notification_center_screen.dart';
import './screens/post_detail_screen.dart';
import './screens/edit_post_screen.dart';
import './providers/posts.dart';
import 'providers/Comments.dart';
import './providers/auth.dart';
import './providers/notifications.dart';


class MainTab extends StatelessWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MapProvider>(create: (_) => MapProvider()),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Posts>(
          create: (_) => Posts('', '', []),
          update: (ctx, auth, previousPosts) => Posts(
            auth.token,
            auth.userId,
            previousPosts == null ? [] : previousPosts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Comments>(
          create: (_) => Comments('', '', []),
          update: (ctx, auth, previousComments) => Comments(
            auth.token,
            auth.userId,
            previousComments == null ? [] : previousComments.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Notifications>(
          create: (_) => Notifications('', '', []),
          update: (ctx, auth, previousNotifications) => Notifications(
            auth.token,
            auth.userId,
            previousNotifications == null ? [] : previousNotifications.items,
          ),
        ),
      ],
      // child: Scaffold(
      //   body: StreamBuilder<User?>(
      //       stream: FirebaseAuth.instance.authStateChanges(),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           return MainTabWidget();
      //         } else {
      //           return LoginPage();
      //         }
      //       }
      //   ),
      // )
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Be Dining',
          theme: ThemeData(
            primaryColor: Colors.red, // 로그인 버튼 색
            fontFamily: 'pretendard',
          ),
          home: auth.isAuth
              ? MainTabWidget()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? SplashScreen()
                : LoginPage(), // Board -> Auth
          ),
          routes: {
            BoardScreen.routeName: (ctx) => BoardScreen(),
            PostDetailScreen.routeName: (ctx) => PostDetailScreen(),
            EditPostScreen.routeName: (ctx) => EditPostScreen(),
            NotiCenterScreen.routeName: (ctx) => NotiCenterScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
          },
        ),
      ),
    );
  }
}

class MainTabWidget extends StatefulWidget {
  const MainTabWidget({Key? key}) : super(key: key);

  @override
  State<MainTabWidget> createState() => MainTabWidgetState();
}

class MainTabWidgetState extends State<MainTabWidget> {
  final _user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);

    final List<Widget> _widgetOptions = <Widget>[
      BoardScreen(),
      EatingAlonePage2(mapProvider: mapProvider),
      RecRoulette(),
      MyPage()
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // 앱바의 높이를 설정
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: Center(
            child: Image.asset(
              'assets/images/logo.png', // 로고 이미지 경로
              height: 50, // 원하는 이미지 높이로 설정
            ),
          ),
          elevation: 0,
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: "같이 먹자",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_outlined),
            label: '혼밥 최고',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            label: '메뉴 추천',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xffBF2142),
        unselectedItemColor: Colors.grey,
      ),

    );
  }
}