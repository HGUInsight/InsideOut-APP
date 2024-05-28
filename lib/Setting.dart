import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'mainpage.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(width: 16,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '유저 이름',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '센터이름',
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
              leading: Icon(Icons.home),
              title: Text('센터'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
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
              onTap: () {
                // Log out
              },
            ),
          ],
        ),
      ),
    );
  }
}
