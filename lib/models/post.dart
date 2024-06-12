class Post {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? userId;
  final String? tags; // 태그
  final int? minPeople; // 최소인원
  final int? maxPeople; // 최대인원
  final DateTime? deadline; // 마감시간

  bool isBookmarked = false;

  void toggleBookmark() {
    isBookmarked = !isBookmarked;
  }



  Post(
      {this.id,
        this.title,
        this.contents,
        this.datetime,
        this.userId,
        this.tags,
        this.minPeople,
        this.maxPeople,
        this.deadline});
}

// Post 클래스의 북마크 상태를 토글하는 함수
extension on Post {
  void toggleBookmark() {
    isBookmarked = !isBookmarked;
    // 실제 데이터베이스에 변경사항을 저장하려면 여기에 코드 추가
  }
}

