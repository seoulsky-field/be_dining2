import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login.dart';
import 'main_tab.dart';

enum Gender {man, woman}

class RegInfoWidget extends StatefulWidget {
  final String nickname;
  final String email;
  final String password;
  const RegInfoWidget({super.key, required this.nickname, required this.email, required this.password});

  @override
  State<RegInfoWidget> createState() => _RegInfoWidgetState();
}

class _RegInfoWidgetState extends State<RegInfoWidget> {
  Gender? _gender = Gender.man;
  String _birth = "20000101";
  String _genderString = "male";
  late String _nickname;
  late String _email;
  late String _password;

  final TextEditingController studentNumberController = TextEditingController();
  final TextEditingController collegesController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  String _studentNumberCheckMessage = "";
  Color _studentNumberCheckColor = Colors.red;
  bool _studentNumberCheckAlert = false;

  bool _checkStudentNumber() {
    final studentNumber = studentNumberController.text;
    if (studentNumber.isEmpty) {
      setState(() {
        _studentNumberCheckMessage = '학번을 입력해주세요.';;
        _studentNumberCheckColor = Colors.red;
        _studentNumberCheckAlert = true;
      });
      return false;
    }else if (studentNumberController.text.length != 8) {
      setState(() {
        _studentNumberCheckMessage = '학번 8자리를 정확히 입력해주세요.';
        _studentNumberCheckColor = Colors.red;
        _studentNumberCheckAlert = true;
      });
      return false;
    }else {
      setState(() {
        _studentNumberCheckAlert = false;
      });
      return true;
    }
  }

  String _collegesCheckMessage = "";
  Color _collegesCheckColor = Colors.red;
  bool _collegesCheckAlert = false;

  bool _checkColleges() {
    final colleges = collegesController.text;
    final department = departmentController.text;
    if (colleges.isEmpty || department.isEmpty) {
      setState(() {
        _collegesCheckMessage = '단과대학 또는 학과를 입력해주세요.';
        _collegesCheckColor = Colors.red;
        _collegesCheckAlert = true;
      });
      return false;
    }else {
      setState(() {
        _collegesCheckAlert = false;
      });
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _email = widget.email;
    _password = widget.password;
  }

  Future _createAccount() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );

    _addUserDetails();
  }

  void _addUserDetails() {
    final config = {
      'nickname': _nickname,
      'student_number': studentNumberController.text.trim(),
      'colleges': collegesController.text.trim(),
      'department': departmentController.text.trim(),
      'sex': _genderString,
      'birth': _birth
    };

    FirebaseFirestore.instance
        .collection('users')
        .doc(_email)
        .set(config);

    FirebaseFirestore.instance
        .collection('double_check')
        .doc('nickname')
        .set({_nickname: true}, SetOptions(merge: true) );

    FirebaseFirestore.instance
        .collection('double_check')
        .doc('email')
        .set({_email: true}, SetOptions(merge: true) );
  }

  @override
  void dispose() {
    studentNumberController.dispose();
    collegesController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain
              ), const SizedBox(height: 20),
              SizedBox(
                height: 30,
                child: Text(
                    textAlign: TextAlign.center,
                    "$_nickname님, 반갑습니다!",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )
                ),
              ), const SizedBox(height: 10),
              const SizedBox(
                height: 50,
                child: Text(
                    textAlign: TextAlign.center,
                    "원활한 서비스 이용을 위해\n아래 정보를 입력해주세요.",
                    style: TextStyle(
                        fontSize: 13,
                        // fontWeight: FontWeight.bold
                    )
                ),
              ), const SizedBox(height: 20),
              SizedBox(
                  height: 20,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      text: '학번',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ), const SizedBox(height: 5),
              SizedBox(
                height: 45,
                child: TextField(
                  obscureText: false,
                  controller: studentNumberController,
                  textAlignVertical: TextAlignVertical.bottom,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: InputDecoration(
                    hintText: '학번 8자리를 입력해주세요.',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7)
                    ),
                  ),
                  style: const TextStyle(
                      fontSize: 14
                  ),
                  onChanged: (text) => { _checkStudentNumber() },
                ),
              ), const SizedBox(height: 5),
              Visibility(
                visible: _studentNumberCheckAlert,
                child: SizedBox(
                  height: 20,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.info_outline, size: 15, color: _studentNumberCheckColor),
                          ),
                        ),
                        TextSpan(
                          text: _studentNumberCheckMessage,
                          style: TextStyle(
                              fontSize: 12,
                              color: _studentNumberCheckColor
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), const SizedBox(height: 20),
              SizedBox(
                  height: 20,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      text: '단과대학 / 학과',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ), const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        obscureText: false,
                        controller: collegesController,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          hintText: '예) SW융합대학',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                        ),
                        style: const TextStyle(
                            fontSize: 14
                        ),
                        onChanged: (text) => { _checkColleges() },
                      ),
                    ),
                  ),
                  const Text("      "),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        obscureText: false,
                        controller: departmentController,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          hintText: '예) 소프트웨어학과',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)
                          ),
                        ),
                        style: const TextStyle(
                            fontSize: 14
                        ),
                        onChanged: (text) => { _checkColleges() },
                      ),
                    ),
                  ),
                ],
              ), const SizedBox(height: 5),
              Visibility(
                visible: _collegesCheckAlert,
                child: SizedBox(
                  height: 20,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.info_outline, size: 15, color: _collegesCheckColor),
                          ),
                        ),
                        TextSpan(
                          text: _collegesCheckMessage,
                          style: TextStyle(
                              fontSize: 12,
                              color: _collegesCheckColor
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ), const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 20,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: const TextSpan(
                          text: '성별',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Radio<Gender>(
                            value: Gender.man,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                                _genderString = "male";
                              });
                            }),
                        const Expanded(
                          child: Text('남성'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Radio<Gender>(
                            value: Gender.woman,
                            groupValue: _gender,
                            onChanged: (Gender? value) {
                              setState(() {
                                _gender = value;
                                _genderString = "female";
                              });
                            }),
                        const Expanded(
                          child: Text('여성'),
                        )
                      ],
                    ),
                  ),
                ],
              ), const SizedBox(height: 20),
              SizedBox(
                  height: 20,
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      text: '생년월일',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ), const SizedBox(height: 5),
              SizedBox(
                height: 120,
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    // dateOrder: DatePickerDateOrder.ymd,
                    initialDateTime: DateTime(2000, 1, 1),
                    onDateTimeChanged: (DateTime newDateTime) {
                      _birth = '${newDateTime.year}${newDateTime.month.toString().padLeft(2, '0')}${newDateTime.day.toString().padLeft(2, '0')}';
                    },
                  ),
                )
              ), const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                      width: 1.25, color: Color(0xffbf2142)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () {
                  if (_checkStudentNumber() && _checkColleges()) {
                    _createAccount();
                    Navigator.of(context).push(_createRoute());
                  } else {
                    null;
                  }
                },
                child: const Text(
                    '입력 완료',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xffbf2142),
                        fontWeight: FontWeight.bold
                    )
                ),
              ), const SizedBox(height: 10),
            ],
          ),
        ),
      )
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainTab(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        });
  }
}