import 'package:be_dining/screens/serach_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts.dart';
import '../screens/edit_post_screen.dart';
import '../widgets/post_item.dart';
import '../widgets/app_drawer.dart';

// 게시글 메인 스크린

class BoardScreen extends StatelessWidget {
  static const routeName = './board';
  const BoardScreen({Key? key}) : super(key: key);

  Future<void> _refreshPosts(BuildContext context) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // 앱바 높이를 더 키움
        child: AppBar(
          centerTitle: true,
          title: Image.asset('assets/images/logo.png', height: 60), // 로고 크기 확대 및 가운데 배치
          actions: <Widget>[
            // 검색 버튼
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed(SearchScreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // 배경을 흰색으로 설정
        child: FutureBuilder(
          future: _refreshPosts(context),
          builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
              ? Center(
            child: CircularProgressIndicator(), // 새로고침
          )
              : RefreshIndicator(
            onRefresh: () => _refreshPosts(context),
            child: Consumer<Posts>(
              builder: (ctx, postsData, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0), // 좌우 패딩 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10), // 공지사항 텍스트 위 공간 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '공지사항',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '더보기',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 테두리
                        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            '필독! 비다이닝 서비스 사용 설명서',
                            style: TextStyle( fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30), // 모집글 텍스트 위 공간 추가
                    Text(
                      '모집글',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: postsData.items.length,
                        itemBuilder: (_, i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0), // 항목 간 간격
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2.0), // 테두리
                              borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // 카드 둥근 모서리
                                ),
                                child: Column(
                                  children: [
                                    PostItem(
                                      postsData.items[i].id,
                                    ),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditPostScreen.routeName, arguments: {'postId': null});
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.red,
      ),
    );
  }
}

