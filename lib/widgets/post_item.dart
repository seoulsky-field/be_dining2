import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../screens/post_detail_screen.dart';
import '../providers/posts.dart';
import '../providers/Comments.dart';

// 게시글 타일 내용

class PostItem extends StatefulWidget {
  final String? id;

  PostItem(this.id);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<Posts>(context, listen: false).items;
    final postIndex = posts.indexWhere((post) => post.id == widget.id);
    if (postIndex < 0) {
      return ListTile(
        title: Text('Post not found'),
        subtitle: Text('Unable to load post details.'),
      );
    }
    final post = posts[postIndex];

    // 해시태그 랜덤 선택
    final random = Random();
    final tags1 = ['#남녀무관', '#남자만', '#여자만'];
    final tags2 = ['#24학번만', '#20학번만', '#21학번만'];
    final selectedTags = [
      tags1[random.nextInt(tags1.length)],
      tags2[random.nextInt(tags2.length)],
    ];

    return Stack(
      children: [
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 5),
              // 태그 디자인
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
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '날짜 : ${DateFormat('MM월 dd일 hh시 mm분').format(post.datetime!)}',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 18.0), // 여백 왜 안되냐 ㅠ
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('n/${post.maxPeople} 명', style: TextStyle(fontSize: 14)),
                    Text('(최소인원 ${post.minPeople}명)', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
          onTap: () async {
            try {
              await Provider.of<Comments>(context, listen: false)
                  .fetchAndSetComments(widget.id!);
              Navigator.of(context)
                  .pushNamed(PostDetailScreen.routeName, arguments: widget.id);
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load comments: $error'),
                ),
              );
            }
          },
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(
              post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: post.isBookmarked ? Colors.red : Colors.red,
              size: 30, // 아이콘 크기
            ),
            onPressed: () {
              setState(() {
                post.isBookmarked = !post.isBookmarked;
              });
            },
          ),
        ),
      ],
    );
  }
}
