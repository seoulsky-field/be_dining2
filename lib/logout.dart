import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _user = FirebaseAuth.instance.currentUser!;
  // String nickname = "";
  //
  // Future<String> _getUserNickname() async {
  //   final userInfo = FirebaseFirestore.instance
  //       .collection('users').doc(_user.email);
  //
  //   await userInfo.get().then((DocumentSnapshot documentSnapshot) {
  //     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
  //     nickname = data['nickname'];
  //     return data['nickname'];
  //   });
  //
  //   return "";
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: IconButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                        width: 12.25, color: Color(0xffbf2142)),
                    shape: const CircleBorder(),
                  ), icon: const Icon(Icons.person, size: 70, color: Colors.black),
                ),
              ), const SizedBox(height: 10),
              // FutureBuilder<String>(
              //   future: _getUserNickname(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       return Text('Text: ${snapshot.data!}');
              //     }
              //   },
              // ),
              Text(
                'nickname: ${_user.email}',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ), const SizedBox(height: 10),
              // Text(
              //   '00대학 00학과 ${_user.email}',
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ), const SizedBox(height: 30),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                        width: 1.25, color: Color(0xffbf2142)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                      '문의하기',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffbf2142),
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ), const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                        width: 1.25, color: Color(0xffbf2142)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                      '비밀번호 변경',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffbf2142),
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              ), const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: ElevatedButton(
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
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text(
                      '로그아웃',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xffbf2142),
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

// Stream<DocumentSnapshot> provideDocumentFieldStream(final _user) {
//   return FirebaseFirestore.instance
//       .collection('users')
//       .doc(_user.email)
//       .snapshots();
// }
