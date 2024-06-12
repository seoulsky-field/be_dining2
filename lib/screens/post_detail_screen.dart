import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/edit_post_screen.dart';
import '../providers/auth.dart';
import '../providers/Comments.dart';
import '../providers/notifications.dart';
import '../providers/posts.dart';
import '../widgets/comment_item.dart';
import '../models/comment.dart';
import '../models/notification.dart' as noti;

// 특정 게시글 세부 정보 화면
class PostDetailScreen extends StatefulWidget {
  static const routeName = './postDetail'; // 라우트 이름 정의.

  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  var _isLoading = false; // 로딩 상태를 나타내는 변수
  var _isParticipating = false; // 참가 신청 상태를 나타내는 변수
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController(); // 댓글 입력란의 텍스트 컨트롤러

  // 게시글 및 댓글 새로고침 함수
  Future<void> _refreshPosts(BuildContext context, String postId) async {
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
    await Provider.of<Comments>(context, listen: false).fetchAndSetComments(postId);
  }

  // 키보드 해제
  @override
  void dispose() {
    _commentTextEditController.dispose();
    super.dispose();
  }

  void _showParticipationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('참가 신청'),
        content: Text('참가 신청 후 수락시 취소가 불가능합니다.'),
        actions: <Widget>[
          TextButton(
            child: Text('취소', style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          TextButton(
            child: Text('신청 하기', style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {
              setState(() {
                _isParticipating = true;
              });
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 라우트에서 전달된 게시글 ID를 가져옵니다.
    final id = ModalRoute.of(context)!.settings.arguments as String;
    // ID를 이용해 해당 게시글을 가져옵니다.
    final post = Provider.of<Posts>(context).items.firstWhere((post) => post.id == id);
    // 모든 댓글을 가져옵니다.
    final comments = Provider.of<Comments>(context).items;
    // 작성자임을 구분하기 위해 사용자 ID를 가져옵니다.
    final authUserId = Provider.of<Auth>(context, listen: false).userId as String;

    // 해시태그 랜덤 선택
    final random = Random();
    final tags1 = ['#남녀무관', '#남자만', '#여자만'];
    final tags2 = ['#24학번만', '#20학번만', '#21학번만'];
    final selectedTags = [
      tags1[random.nextInt(tags1.length)],
      tags2[random.nextInt(tags2.length)],
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '상세보기',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // 글쓴이가 자기 자신이면 수정, 삭제 버튼 활성화
        actions: authUserId == post.userId
            ? <Widget>[
          // 수정 버튼
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(EditPostScreen.routeName, arguments: {'postId': id});
            },
          ),
          // 삭제 버튼
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // 삭제 확인 다이얼로그
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('삭제'),
                  content: Text('게시글을 삭제할까요?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        '취소',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text(
                        '확인',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        Navigator.of(ctx).pop(true);
                        try {
                          Navigator.pop(context);
                          await Provider.of<Posts>(context, listen: false).deletePost(id);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "삭제하지 못했습니다.",
                              textAlign: TextAlign.center,
                            ),
                          ));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ]
            : null,
      ),

      // 댓글 목록 디자인
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _commentFocusNode.unfocus();
            },
            child: RefreshIndicator(
              onRefresh: () => _refreshPosts(context, id),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.0), // 양옆에 패딩 값 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 아이콘, 아이디, 날짜
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'soyeonna',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        '20학번 여자',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: post.isBookmarked ? Colors.red : Colors.red,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            post.isBookmarked = !post.isBookmarked;
                          });
                        },
                      ),
                    ),
                    // 제목
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        post.title!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    // 내용
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        post.contents!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    // 해시태그
                    Row(
                      children: selectedTags.map((tag) {
                        return Container(
                          margin: EdgeInsets.only(right: 5),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    // 모집 인원 및 마감 시간
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'n/${post.maxPeople} 명 (최소인원 ${post.minPeople}명)\n',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${DateFormat('MM월 dd일 hh시 mm분').format(post.datetime!)} 마감',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    // 댓글 목록
                    comments.isEmpty
                        ? Center(
                      child: Text('No comments'),
                    )
                        : Column(
                      children: comments.map((comment) => CommentItem(comment.id)).toList(),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          // 참가 신청하기
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Checkbox(
                  value: _isParticipating,
                  onChanged: (value) {
                    if (value == true) {
                      _showParticipationDialog();
                    } else {
                      setState(() {
                        _isParticipating = false;
                      });
                    }
                  },
                ),
                Text(
                  '참가 신청하기       ',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          // 댓글 작성
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          focusNode: _commentFocusNode,
                          controller: _commentTextEditController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return '댓글을 입력하세요.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            hintText: "댓글을 입력하세요.",
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        String commentText = _commentTextEditController.text;
                        print('input comment: ' + _commentTextEditController.text);

                        if (_formKey.currentState!.validate()) {
                          _addComment(post.id!, commentText);

                          _commentTextEditController.clear();
                          _commentFocusNode.unfocus();

                          if (post.userId != authUserId) {
                            _addNotification(post.title!, commentText, post.id!, post.userId!);
                          }
                        } else {
                          null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 댓글 추가 함수
  Future<void> _addComment(String postId, String contents) async {
    final comment = Comment(contents: contents, postId: postId, userId: null, datetime: null, id: null);
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Comments>(context, listen: false).addComment(comment);
    _refreshPosts(context, postId);
    setState(() {
      _isLoading = false;
    });
  }

  // 알림 추가 함수
  Future<void> _addNotification(String postTitle, String contents, String postId, String receiverId) async {
    final notification = noti.Notification(
      title: "새로운 댓글: " + postTitle,
      contents: contents,
      datetime: null,
      id: null,
      postId: postId,
      receiverId: receiverId,
    );
    await Provider.of<Notifications>(context, listen: false).addNotification(notification);
  }
}
