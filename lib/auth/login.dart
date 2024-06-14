import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insideout/mainpage.dart';
import 'package:insideout/signup/Signup.dart';
import 'package:insideout/style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _isObscure = true;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithIdAndPassword() async {
    final id = _idController.text;
    final pwd = _pwdController.text;
    debugPrint("id :$id pwd: $pwd");
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: id)
          .where('pwd', isEqualTo: pwd)
          .get();
      debugPrint("snapshot : ${snapshot.docs[0].data()}");
      final userData = snapshot.docs[0].data() as Map<String, dynamic>;
      if (snapshot.docs.isNotEmpty) {
        debugPrint("email : ${userData['email']}");
        final credential = EmailAuthProvider.credential(
          email: userData['email'],
          password: pwd,
        );
        debugPrint("credential made!!");
        await FirebaseAuth.instance.signInWithCredential(credential);

        print("Signed in successfully.");
      } else {
        _showErrorDialog('존재하지 않는 아이디입니다.');
      }
    } catch (e) {
      _showErrorDialog('로그인 중 오류가 발생했습니다.');
      print("debug error :$e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('로그인 실패'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 100),
            Text('환영합니다!', style: MyTextStyles.titleTextStyle),
            Text('아직 회원이 아니신가요?', style: MyTextStyles.subtitleTextStyle),
            SizedBox(height: 16.0),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _pwdController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: Text('비밀번호를 잊어버리셨습니까?',style: MyTextStyles.miniTextStyle),
              ),
            ),
            SizedBox(height: 16.0),
            submitButton('로그인', signInWithIdAndPassword),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text('회원가입',style: MyTextStyles.subtitleTextStyle,),
            ),
            SizedBox(height: 120.0),
            submitButton('GOOGLE', signInWithGoogle),
          ],
        ),
      ),
    );
  }
}
