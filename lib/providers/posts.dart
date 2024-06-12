import 'dart:convert'; // JSON 인코딩 및 디코딩을 위해 사용
import 'dart:async'; // 비동기 처리를 위해 사용

import 'package:flutter/widgets.dart'; // 플러터 위젯을 사용하기 위해 필요
import 'package:http/http.dart' as http; // HTTP 요청을 보내기 위해 사용

import '../models/http_exception.dart'; // 사용자 정의 예외 처리 클래스
import '../models/post.dart'; // 게시물 모델 클래스

// Posts 클래스는 ChangeNotifier를 상속받아 상태 관리를 담당
class Posts with ChangeNotifier {
  List<Post> _items = []; // 게시물 목록을 저장하는 리스트
  final String? authToken; // 인증 토큰
  final String? userId; // 사용자 ID

  // 생성자에서 인증 토큰, 사용자 ID 및 초기 게시물 목록을 설정
  Posts(this.authToken, this.userId, this._items);

  // 게시물 목록을 반환하는 getter
  List<Post> get items {
    // 게시물을 날짜 순으로 정렬 (최신순)
    _items.sort((a, b) {
      return b.datetime!.compareTo(a.datetime!);
    });
    return [..._items]; // 불변 리스트로 반환
  }

  // 게시물 데이터를 서버에서 가져와 설정하는 함수
  Future<void> fetchAndSetPosts() async {
    var url = Uri.parse(
        'https://bediningboard-default-rtdb.firebaseio.com/posts.json?auth=$authToken');
    try {
      final response = await http.get(url); // GET 요청을 통해 데이터 가져오기
      final extractedData = json.decode(response.body) as Map<String, dynamic>; // JSON 디코딩
      if (extractedData == null) { // 데이터가 없을 경우
        return;
      }

      final List<Post> loadedPosts = []; // 로드된 게시물을 저장할 리스트
      extractedData.forEach((postId, postData) {
        loadedPosts.add(Post( // 각 게시물을 Post 객체로 변환하여 리스트에 추가
          id: postId,
          title: postData['title'],
          contents: postData['contents'],
          datetime: DateTime.parse(postData['datetime']),
          userId: postData['creatorId'],
          tags: postData['tags'], // 해시태그 추가
          minPeople: postData['minPeople'], // 최소 인원 추가
          maxPeople: postData['maxPeople'], // 최대 인원 추가
          deadline: DateTime.parse(postData['deadline']), // 마감 시간 추가
        ));
      });
      _items = loadedPosts; // 로드된 게시물로 아이템 목록 설정
      notifyListeners(); // 리스너에게 변경 사항 알림
    } catch (error) {
      throw (error);
    }
  }

  // 검색어를 기반으로 게시물을 검색하는 함수
  Future<void> searchPosts(String searchText) async {
    var url = Uri.parse(
        'https://bediningboard-default-rtdb.firebaseio.com/posts.json?auth=$authToken');
    try {
      final response = await http.get(url); // GET 요청을 통해 데이터 가져오기
      final extractedData = json.decode(response.body) as Map<String, dynamic>; // JSON 디코딩
      if (extractedData == null) { // 데이터가 없을 경우
        return;
      }

      final List<Post> loadedPosts = []; // 로드된 게시물을 저장할 리스트
      extractedData.forEach((postId, postData) {
        String title = postData['title'];
        String contents = postData['contents'];
        if (title.contains(searchText) || contents.contains(searchText)) { // 제목 또는 내용에 검색어가 포함된 경우
          loadedPosts.add(Post( // 해당 게시물을 리스트에 추가
            id: postId,
            title: postData['title'],
            contents: postData['contents'],
            datetime: DateTime.parse(postData['datetime']),
            userId: postData['creatorId'],
            tags: postData['tags'], // 해시태그 추가
            minPeople: postData['minPeople'], // 최소 인원 추가
            maxPeople: postData['maxPeople'], // 최대 인원 추가
            deadline: DateTime.parse(postData['deadline']), // 마감 시간 추가
          ));
        }
      });
      _items = loadedPosts; // 로드된 게시물로 아이템 목록 설정
      notifyListeners(); // 리스너에게 변경 사항 알림
    } catch (error) {
      throw (error);
    }
  }

  // 새로운 게시물을 추가하는 함수
  Future<void> addPost(Post post) async {
    final url = Uri.parse(
        'https://bediningboard-default-rtdb.firebaseio.com/posts.json?auth=$authToken');
    final timeStamp = DateTime.now(); // 현재 시간을 타임스탬프로 저장

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': post.title,
          'contents': post.contents,
          'datetime': timeStamp.toIso8601String(),
          'creatorId': post.userId,
          'tags': post.tags, // 해시태그 추가
          'minPeople': post.minPeople, // 최소 인원 추가
          'maxPeople': post.maxPeople, // 최대 인원 추가
          'deadline': post.deadline?.toIso8601String(), // 마감 시간 추가
        }),
      );

      final newPost = Post(
        title: post.title,
        contents: post.contents,
        datetime: timeStamp,
        userId: post.userId,
        id: json.decode(response.body)['name'], // 서버에서 생성된 ID 사용
        tags: post.tags, // 해시태그 추가
        minPeople: post.minPeople, // 최소 인원 추가
        maxPeople: post.maxPeople, // 최대 인원 추가
        deadline: post.deadline, // 마감 시간 추가
      );

      _items.add(newPost); // 새로운 게시물을 리스트에 추가
      notifyListeners(); // 리스너에게 변경 사항 알림
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // 게시물을 업데이트하는 함수
  Future<void> updatePost(String? id, Post newPost) async {
    final postIndex = _items.indexWhere((post) => post.id == id); // 업데이트할 게시물의 인덱스 찾기
    if (postIndex >= 0) {
      final url = Uri.parse(
          'https://bediningboard-default-rtdb.firebaseio.com/posts/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newPost.title,
            'contents': newPost.contents,
            'tags': newPost.tags, // 해시태그 추가
            'minPeople': newPost.minPeople, // 최소 인원 추가
            'maxPeople': newPost.maxPeople, // 최대 인원 추가
            'deadline': newPost.deadline?.toIso8601String(), // 마감 시간 추가
          }));
      _items[postIndex] = newPost; // 게시물 업데이트
      notifyListeners(); // 리스너에게 변경 사항 알림
    } else {
      print('Cannot find any post of id $id'); // 해당 ID의 게시물을 찾을 수 없는 경우
    }
  }

  // 게시물을 삭제하는 함수
  Future<void> deletePost(String id) async {
    final url = Uri.parse(
        'https://bediningboard-default-rtdb.firebaseio.com/posts/$id.json?auth=$authToken');

    final existingPostIndex = _items.indexWhere((post) => post.id == id); // 삭제할 게시물의 인덱스 찾기
    Post? existingPost = _items[existingPostIndex]; // 삭제할 게시물 저장
    _items.removeAt(existingPostIndex); // 게시물 목록에서 제거

    final response = await http.delete(url); // DELETE 요청을 통해 서버에서 삭제
    if (response.statusCode >= 400) { // 삭제 실패 시
      _items.insert(existingPostIndex, existingPost); // 게시물을 다시 추가
      notifyListeners(); // 리스너에게 변경 사항 알림
      throw HttpException('Could not delete post.'); // 예외 발생
    }
    _items.removeWhere((post) => post.id == id); // 게시물 목록에서 제거
    notifyListeners(); // 리스너에게 변경 사항 알림
    existingPost = null; // 기존 게시물 참조 제거
  }
}
