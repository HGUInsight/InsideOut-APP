import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../signup/Signup.dart';
import '../style.dart';

class TestForm extends StatefulWidget {
  const TestForm({super.key});

  @override
  State<TestForm> createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  int? _selectedOption1;
  int? _selectedOption2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: ColorStyle.bgColor1,
                  content: const Text('계정 생성이\n완료되었습니다!',style: MyTextStyles.titleTextStyle,),
                  actions: [
                    submitButton('예',()=>Navigator.of(context).pop())
                  ],
                );
              },
            );
            // Close the screen
            context.go('/test');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: 0.5, // Set the progress value as needed
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
            ),
            SizedBox(height: 16),
            Text(
              '※ 아래의 문항을 잘 살펴보고 자신에게 해당되는 곳에 체크해 보세요',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionCard(
                    question: '1. 혼자 있을 때 어떤 음성을 들은 적이 있습니까?',
                    options: ['없음', '가끔', '자주', '거의 항상'],
                    selectedOption: _selectedOption1,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption1 = value;
                      });
                    },
                  ),
                  _buildQuestionCard(
                    question: '2. 어떤 사람들이 걸로 보이는 것과 다른 것 같다는 느낌이 든 적이 있습니까?',
                    options: ['없음', '가끔', '자주', '거의 항상'],
                    selectedOption: _selectedOption2,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption2 = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navigationButton('이전', () {
                  // Handle previous button action
                }),
                _navigationButton('다음', () {
                  // Handle next button action
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required String question,
    required List<String> options,
    required int? selectedOption,
    required ValueChanged<int?> onChanged,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            for (int i = 0; i < options.length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                title: Text(options[i]),
                onChanged: onChanged,
                activeColor: Colors.blueGrey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _navigationButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        minimumSize: Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}