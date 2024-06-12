import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯 사용
import 'package:intl/intl.dart'; // 날짜 형식 변환을 위한 패키지
import 'package:provider/provider.dart'; // 상태 관리를 위한 Provider 패키지
import '../providers/Comments.dart'; // Comments 프로바이더 import
import '../providers/auth.dart'; // Auth 프로바이더 import

class CommentItem extends StatelessWidget {
  final String? id; // 댓글의 ID를 저장하는 변수
  CommentItem(
      this.id,
      );

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<Comments>(context, listen: false).items; // Comments 프로바이더에서 댓글 목록을 가져옴
    final auth_uid = Provider.of<Auth>(context, listen: false).userId; // Auth 프로바이더에서 현재 사용자 ID를 가져옴
    final comment = comments.firstWhere((comment) => comment.id == id); // 해당 ID에 해당하는 댓글을 찾음
    int timediff = DateTime.now().day - comment.datetime!.day; // 현재 시간과 댓글 작성 시간의 차이 계산

    String dt = ''; // 댓글 작성 시간을 저장할 변수
    if (timediff >= 1) {
      dt = timediff.toString() + "일 전"; // 1일 이상 차이가 나면 "일 전" 형식으로 표시
    } else {
      dt = DateFormat("HH시 mm분 작성").format(comment.datetime!); // 그렇지 않으면 시간 형식으로 표시
    }

    return (comment.userId != null) // 댓글 작성자가 있는 경우에만 표시
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        ListTile(
          dense: true, // 타일을 더 컴팩트하게 만듦
          leading: CircleAvatar( // 댓글 작성자 아이콘
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              child: Icon(
                Icons.comment,
                color: Color(0xffCCCCCC),
              ),
            ),
          ),
          title: Text(
            comment.userId!.substring(0, 5) + '****', // 댓글 작성자의 ID 일부
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '20학번 남자\n$dt', // 학번과 성별, 작성 시간 표시
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: comment.userId == auth_uid // 댓글 작성자와 현재 사용자가 같은 경우 삭제 버튼 표시
              ? IconButton(
            icon: Icon(Icons.delete), // 삭제 아이콘
            onPressed: () async {
              showDialog( // 삭제 확인 다이얼로그 표시
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('삭제'),
                  content: Text('선택한 댓글을 삭제할까요?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('취소', style: TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        Navigator.of(ctx).pop(false); // 취소하면 다이얼로그 닫음
                      },
                    ),
                    TextButton(
                      child: Text('확인', style: TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () async {
                        await Provider.of<Comments>(context, listen: false).deleteComment(id!); // 댓글 삭제
                        Navigator.of(ctx).pop(true); // 다이얼로그 닫음
                      },
                    ),
                  ],
                ),
              );
            },
          )
              : null, // 댓글 작성자가 아니면 삭제 버튼 없음
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            comment.contents!, // 댓글 내용 표시
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '답글 달기', // 답글 달기 텍스트
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Divider(
          thickness: 1, // 구분선 두께 설정
        ),
      ],
    )
        : SizedBox(
      height: 0, // 댓글 작성자가 없으면 아무것도 표시하지 않음
    );
  }
}
