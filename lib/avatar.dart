import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insideout/style.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class ExpandedAvatarScreen1 extends StatefulWidget {
  const ExpandedAvatarScreen1({super.key});

  @override
  _ExpandedAvatarScreenState1 createState() => _ExpandedAvatarScreenState1();
}

class _ExpandedAvatarScreenState1 extends State<ExpandedAvatarScreen1> {
  int? userLevel;

  @override
  void initState() {
    super.initState();
    fetchUserLevel();
  }

  Future<void> fetchUserLevel() async {
    var appState = context.read<ApplicationState>();
    String uid = appState.uid;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userLevel = snapshot.docs.first.data()['level'];
          print('User level fetched: $userLevel'); // Debug print
        });
      } else {
        print('No user document found'); // Debug print
      }
    } catch (e) {
      print('Error fetching user level: $e'); // Debug print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        backgroundColor: ColorStyle.bgColor1,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorStyle.mainColor1), // Changed color to white for visibility
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Hero(
                tag: 'avatar',
                child: CircleAvatar(
                  radius: 100,
                  child: Lottie.asset('assets/egg.json'),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (userLevel != null)
              Text(
                'Level: $userLevel',
                style: MyTextStyles.titleTextStyle
              ),
            if (userLevel == null)
              Text(
                'Loading level...',
                style: TextStyle(
                  color: Colors.red, // Adjusted for visibility
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
