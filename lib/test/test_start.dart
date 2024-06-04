import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/app_state.dart';
import 'package:insideout/signup/Signup.dart';
import 'package:insideout/style.dart';
import 'package:provider/provider.dart';

class StartTest extends StatefulWidget {
  const StartTest({super.key});

  @override
  State<StartTest> createState() => _StartTestState();
}

class _StartTestState extends State<StartTest> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        backgroundColor: ColorStyle.bgColor1,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: () {
            // Close the screen
            context.go("/");
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${appState.user.name}님,',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 24, color: ColorStyle.mainColor1),
              ),
              SizedBox(height: 16),
              Text(
                '멘탈지수 설문조사를\n시작하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: ColorStyle.mainColor1),
              ),
              Spacer(),
              submitButton('시작하기', () => context.go('/test/page')),
            ],
          ),
        ),
      ),
    );
  }
}
