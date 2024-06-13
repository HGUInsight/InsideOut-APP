import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/checklist.dart';
import 'package:insideout/firebase_options.dart';
import 'package:insideout/json/upload_json.dart';
import 'package:insideout/mainpage.dart';
import 'package:insideout/navermap.dart';
import 'package:insideout/navigation.dart';
import 'package:insideout/signup/Signup.dart';
import 'package:insideout/signup/Signup2.dart';
import 'package:insideout/signup/signup1.dart';
import 'package:insideout/signup/signup3.dart';
import 'package:insideout/test/test_form.dart';
import 'package:insideout/test/test_start.dart';
import 'package:insideout/text_scan.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ko_KR','');
  await _initializeMap();
  //파이어스토어에 Json 추가
  //uploadJsonToFirestore();
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) =>
        Consumer<ApplicationState>(builder: (context, appState, _) {
          return const App();
        })),
  ));
}

Future<void> _initializeMap() async{
  await NaverMapSdk.instance.initialize(
    clientId: '9j4sfz4zz8',
    onAuthFailed: (e) => log("네이버맵 인증오류: $e", name: "onAuthFailed")
  );
}

String docId = "";
bool checked = false;

Future<void> getUserData(String uid) async {
  debugPrint('uid : $uid');
  await FirebaseFirestore.instance
      .collection('user')
      .where("uid", isEqualTo: uid)
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      debugPrint('uid2 : ${value.docs[0].id}');
      docId = value.docs[0].id;
      checked = true;
      debugPrint("checked : $checked");
    } else {
      checked = false;
    }
  });
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          Consumer<ApplicationState>(builder: (context, appState, _) {
            return const Navigation();
          }),
      routes: [
        GoRoute(path: 'checklist', builder: (_, state) => const CheckList()),
        GoRoute(path: 'map', builder: (_, state) => const NaverMapApp()),
        GoRoute(path: 'textscan', builder: (_, state) => const TextScan()),
      ],
    ),
    GoRoute(
      path: "/login",
      builder: (_, state) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getUserData(snapshot.data!.uid),
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userDataSnapshot.hasError) {
                  return const Center(child: Text('Error loading user data'));
                } else {
                  if (checked) {
                    return const Navigation();
                  } else {
                    return const SignUp();
                  }
                }
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
      routes: [
        GoRoute(path: 'signup', builder: (_, state) => const SignUp()),
        GoRoute(path: 'signup1', builder: (_, state) => const SignUpFirst()),
        GoRoute(path: 'signup2', builder: (_, state) => const SignUpSecond()),
        GoRoute(path: 'signup3', builder: (_, state) => const SignupThird()),
      ],
    ),
    GoRoute(
      path: "/test",
      builder: (context, state) => const StartTest(),
      routes: [
        GoRoute(path: 'page', builder: (context, state) => const TestForm())
      ],
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
