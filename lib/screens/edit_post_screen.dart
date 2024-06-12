import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart'; // 게시물 모델 클래스
import '../providers/posts.dart'; // 게시물 관리 프로바이더
import '../providers/auth.dart'; // 인증 관리 프로바이더

class EditPostScreen extends StatefulWidget {
  static const routeName = './editPost'; // 라우트 이름 정의

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _contentsFocusNode = FocusNode(); // 내용 입력 필드에 포커스를 관리하기 위한 노드
  final _form = GlobalKey<FormState>(); // 폼 상태를 관리하기 위한 키

  var _editedPost = Post(
    id: null,
    title: '',
    contents: '',
    datetime: null,
    userId: '',
    tags: '',
    minPeople: null,
    maxPeople: null,
    deadline: null,
  );

  var _initValues = {
    'title': '',
    'contents': '',
    'tags': '',
    'minPeople': '',
    'maxPeople': '',
    'deadline': '',
  };

  var _isInit = true; // 초기화 여부를 확인하는 플래그
  var _isLoading = false; // 로딩 상태를 나타내는 플래그
  var arguments = null; // 전달된 인자를 저장

  List<String> _tags = []; // 해시태그를 저장하는 리스트
  final int _maxTags = 3; // 최대 해시태그 수
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    arguments = ModalRoute.of(context)!.settings.arguments as Map; // 전달된 인자 받아오기
    if (_isInit) {
      final postId = arguments['postId']; // 게시물 ID 받아오기
      if (postId != null) {
        // 수정 모드인 경우
        _editedPost = Provider.of<Posts>(context, listen: false)
            .items
            .firstWhere((post) => post.id == postId);
        _initValues = {
          'title': _editedPost.title ?? '',
          'contents': _editedPost.contents ?? '',
          'tags': _editedPost.tags ?? '',
          'minPeople': _editedPost.minPeople?.toString() ?? '',
          'maxPeople': _editedPost.maxPeople?.toString() ?? '',
          'deadline': _editedPost.deadline?.toIso8601String() ?? '',
        };
        _tags = _editedPost.tags!.split(',').where((tag) => tag.isNotEmpty).toList();
      }
    }
    _isInit = false; // 초기화 완료
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentsFocusNode.dispose(); // 포커스 노드 해제
    super.dispose();
  }

  // 폼을 저장하는 함수
  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate(); // 폼 검증
    if (!isValid) {
      return;
    }
    _form.currentState!.save(); // 폼 저장

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    if (_editedPost.id != null) {
      // 수정 모드
      await Provider.of<Posts>(context, listen: false)
          .updatePost(_editedPost.id, _editedPost);
    } else {
      // 추가 모드
      try {
        await Provider.of<Posts>(context, listen: false).addPost(_editedPost);
      } catch (error) {
        // 오류 발생 시 다이얼로그 표시
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred.'),
            content: Text('오류가 발생했습니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false; // 로딩 종료
    });
    Navigator.of(context).pop(); // 페이지 닫기
  }

  // 해시태그를 추가하는 함수
  void _addTag(String tag) {
    if (_tags.length < _maxTags && tag.isNotEmpty) {
      setState(() {
        _tags.add(tag);
        _editedPost = Post(
          title: _editedPost.title,
          contents: _editedPost.contents,
          datetime: _editedPost.datetime,
          userId: _editedPost.userId,
          tags: _tags.join(','), // 해시태그를 ','로 구분하여 저장
          minPeople: _editedPost.minPeople,
          maxPeople: _editedPost.maxPeople,
          deadline: _editedPost.deadline,
          id: _editedPost.id,
        );
      });
    }
  }

  // 해시태그 입력 다이얼로그
  void _showTagInputDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('해시태그 입력'),
        content: TextField(
          maxLength: 6, // 해시태그 최대 길이 설정
          decoration: InputDecoration(
            labelText: '해시태그 입력',
          ),
          onSubmitted: (value) {
            Navigator.of(ctx).pop();
            setState(() {
              _tags[index] = '#$value';
              _editedPost = Post(
                title: _editedPost.title,
                contents: _editedPost.contents,
                datetime: _editedPost.datetime,
                userId: _editedPost.userId,
                tags: _tags.join(','),
                minPeople: _editedPost.minPeople,
                maxPeople: _editedPost.maxPeople,
                deadline: _editedPost.deadline,
                id: _editedPost.id,
              );
            });
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // 날짜 선택 다이얼로그 표시 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _editedPost = Post(
          title: _editedPost.title,
          contents: _editedPost.contents,
          datetime: _editedPost.datetime,
          userId: _editedPost.userId,
          tags: _editedPost.tags,
          minPeople: _editedPost.minPeople,
          maxPeople: _editedPost.maxPeople,
          deadline: picked,
          id: _editedPost.id,
        );
      });
    }
  }

  // 시간 선택 다이얼로그 표시 함수
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Auth>(context).userId; // 현재 사용자 ID 가져오기

    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색 설정
      appBar: AppBar(
        title: arguments['postId'] != null ? Text('글 수정') : Text('글 작성'), // 페이지 제목 설정
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFB71C1C), // 색상 수정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
              ),
            ),
            onPressed: _saveForm, // 저장 버튼
            child: Text(
              '완료',
              style: TextStyle(color: Colors.white, fontSize: 14), // 텍스트 크기 줄임
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(), // 로딩 중일 때 표시
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0), // 좌우 패딩 추가
        child: Form(
          key: _form,
          child: SingleChildScrollView(


            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.person), // 프로필 사진 아이콘말고 url도 가능
                    ),
                    SizedBox(width: 10),
                    Text(
                      'soyeonna',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _initValues['title'], // 초기 제목 값 설정
                  decoration: InputDecoration(
                    labelText: '제목',
                    labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_contentsFocusNode); // 다음 필드로 포커스 이동
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '제목을 입력해주세요.'; // 제목이 비어있을 때 메시지
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedPost = Post(
                      title: value,
                      contents: _editedPost.contents,
                      datetime: _editedPost.datetime,
                      userId: userId,
                      tags: _editedPost.tags,
                      minPeople: _editedPost.minPeople,
                      maxPeople: _editedPost.maxPeople,
                      deadline: _editedPost.deadline,
                      id: _editedPost.id,
                    );
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _initValues['contents'], // 초기 내용 값 설정
                  decoration:
                  InputDecoration(labelText: '내용을 입력하세요(최대 500자)', labelStyle: TextStyle(color: Colors.grey)),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  focusNode: _contentsFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '내용을 입력해주세요.'; // 내용이 비어있을 때 메시지
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedPost = Post(
                      title: _editedPost.title,
                      contents: value,
                      datetime: _editedPost.datetime,
                      userId: userId,
                      tags: _editedPost.tags,
                      minPeople: _editedPost.minPeople,
                      maxPeople: _editedPost.maxPeople,
                      deadline: _editedPost.deadline,
                      id: _editedPost.id,
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Icon(Icons.group),
                    SizedBox(width: 10),
                    Text('모집 인원', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 20),
                    Text('최소'),
                    DropdownButton<int>(
                      value: _editedPost.minPeople, // 최소 인원 초기값
                      items: List.generate(6, (index) => index + 1)
                          .map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value 인'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _editedPost = Post(
                            title: _editedPost.title,
                            contents: _editedPost.contents,
                            datetime: _editedPost.datetime,
                            userId: userId,
                            tags: _editedPost.tags,
                            minPeople: newValue, // 선택된 최소 인원 설정
                            maxPeople: _editedPost.maxPeople,
                            deadline: _editedPost.deadline,
                            id: _editedPost.id,
                          );
                        });
                      },
                    ),
                    SizedBox(width: 20),
                    Text('최대'),
                    DropdownButton<int>(
                      value: _editedPost.maxPeople, // 최대 인원 초기값
                      items: List.generate(10, (index) => index + 1)
                          .map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value 인'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _editedPost = Post(
                            title: _editedPost.title,
                            contents: _editedPost.contents,
                            datetime: _editedPost.datetime,
                            userId: userId,
                            tags: _editedPost.tags,
                            minPeople: _editedPost.minPeople,
                            maxPeople: newValue, // 선택된 최대 인원 설정
                            deadline: _editedPost.deadline,
                            id: _editedPost.id,
                          );
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Icon(Icons.tag),
                    SizedBox(width: 10),
                    Text('해시태그', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: <Widget>[
                    ..._tags.map((tag) => GestureDetector(
                      onTap: () {
                        _showTagInputDialog(_tags.indexOf(tag));
                      },
                      child: _buildTag(tag),
                    )),
                    if (_tags.length < _maxTags)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _tags.add('#직접입력');
                          });
                        },
                        child: _buildTag('#직접입력'),
                      ),
                    if (_tags.length < _maxTags)
                      GestureDetector(
                        onTap: () {
                          _addTag('#직접입력');
                        },
                        child: _buildTag('+'),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    SizedBox(width: 10),
                    Text('날짜 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                        ),
                        decoration: InputDecoration(labelText: '마감 날짜', labelStyle: TextStyle(color: Colors.black)),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () => _selectDate(context), // 날짜 선택 다이얼로그 표시
                        onSaved: (value) {
                          _editedPost = Post(
                            title: _editedPost.title,
                            contents: _editedPost.contents,
                            datetime: _editedPost.datetime,
                            userId: userId,
                            tags: _editedPost.tags,
                            minPeople: _editedPost.minPeople,
                            maxPeople: _editedPost.maxPeople,
                            deadline: _selectedDate!,
                            id: _editedPost.id,
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context), // 날짜 선택 다이얼로그 표시
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Icon(Icons.access_time),
                    SizedBox(width: 10),
                    Text('만나는 시간', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _selectedTime == null
                              ? ''
                              : '${_selectedTime!.hour}:${_selectedTime!.minute}',
                        ),
                        decoration: InputDecoration(labelText: '만나는 시간', labelStyle: TextStyle(color: Colors.black)),
                        keyboardType: TextInputType.datetime,
                        readOnly: true,
                        onTap: () => _selectTime(context), // 시간 선택 다이얼로그 표시
                        onSaved: (value) {
                          final now = DateTime.now();
                          final selectedTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          );
                          _editedPost = Post(
                            title: _editedPost.title,
                            contents: _editedPost.contents,
                            datetime: _editedPost.datetime,
                            userId: userId,
                            tags: _editedPost.tags,
                            minPeople: _editedPost.minPeople,
                            maxPeople: _editedPost.maxPeople,
                            deadline: selectedTime,
                            id: _editedPost.id,
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context), // 시간 선택 다이얼로그 표시


                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 태그 위젯 생성 함수
  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        tag,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}


