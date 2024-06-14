import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/app_state.dart';
import 'package:insideout/style.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StartTest extends StatefulWidget {
  const StartTest({super.key});

  @override
  State<StartTest> createState() => _StartTestState();
}

class _StartTestState extends State<StartTest> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
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
              SizedBox(
                width: 250.0,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      '${appState.user.name}님,',
                      textAlign: TextAlign.left,
                      textStyle: TextStyle(fontSize: 24, color: ColorStyle.mainColor1),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 500),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 250.0,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      '멘탈지수 설문조사를\n시작하시겠습니까?',
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(fontSize: 24, color: ColorStyle.mainColor1),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 500),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              Spacer(),
              submitButton('시작하기', () => context.go('/test/page')),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton(String text, Function func) {
    return ElevatedButton(
      onPressed: () {
        func();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorStyle.mainColor1,
        minimumSize: Size(200, 50), // Width and height of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: ColorStyle.bgColor1,
          fontSize: 18, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
