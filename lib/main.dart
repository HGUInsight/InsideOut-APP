import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/firebase_options.dart';
import 'package:insideout/mainpage.dart';
import 'package:insideout/navigation.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) =>
        Consumer<ApplicationState>(builder: (context, appState, _) {
          //debugPrint("data loading...");
          //appState.allProducts.clear();
          //appState.fillProducts();
          return const App();
        })),
  ));
}

final _router = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) =>
        Consumer<ApplicationState>(builder: (context, appState, _) {
      //debugPrint("data loading...");
      return Navigation();
    }),
  ),
  GoRoute(
      path: "/login",
      builder: (_, state) => StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //debugPrint('state :'+snapshot.data!.uid);
            if (snapshot.hasData) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection('user').snapshots(),
                builder: (context, userdt) {
                  return const MainPage();
                }
              );
            } else {
              return const LoginPage();
            }
          }))
]);

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
