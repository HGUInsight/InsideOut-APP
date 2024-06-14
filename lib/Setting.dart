import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insideout/app_state.dart';
import 'package:insideout/style.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'avatar.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        backgroundColor: ColorStyle.bgColor1,
        title: const Text('마이페이지', style: MyTextStyles.subtitleTextStyle,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpandedAvatarScreen1(),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'avatar',
                    child: CircleAvatar(
                      radius: 40,
                      child: Lottie.asset('assets/egg.json'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${appState.user.name}님",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      appState.user.center == 'none'
                          ? "센터없음"
                          : appState.user.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('계정 관리'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to account management
              },
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text('텍스트 인식'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/textscan');
                // Navigate to account management
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('센터'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go("/map");
                // Navigate to center
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('알림'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to notifications
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('로그아웃'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () async {
                appState.mental = 0;
                await FirebaseAuth.instance.signOut();
                await _googleSignIn.signOut();
                context.go("/login");
                // Log out
              },
            ),
          ],
        ),
      ),
    );
  }
}
