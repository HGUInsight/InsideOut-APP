import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupThird extends StatefulWidget {
  const SignupThird({super.key});

  @override
  State<SignupThird> createState() => _SignupThirdState();
}

class _SignupThirdState extends State<SignupThird> {

  Future<void> showCompletion() async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('계정 생성이\n완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  int? _selectedInterest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관심사 설문조사'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '당신의 관심사는 무엇인가요?',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedInterest == index ? Colors.grey[800] : Colors.grey[400],
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedInterest = index;
                        });
                      },
                      child: Text('관심사 ${index + 1}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedInterest != null ? () async {
                // Do something when the survey is complete
                await showCompletion();
                context.go("/");
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
              ),
              child: Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
