import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../style.dart';
import 'Signup.dart';

class SignupThird extends StatefulWidget {
  const SignupThird({super.key});

  @override
  State<SignupThird> createState() => _SignupThirdState();
}

class _SignupThirdState extends State<SignupThird> {
  int? _selectedInterest;
  final List<String> interests = ['취업', '공동체', '인간관계', '관심사 1', '관심사 2', '관심사 3'];

  Future<void> showCompletion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorStyle.bgColor1,
          content: const Text('계정 생성이\n완료되었습니다!',style: MyTextStyles.titleTextStyle,),
          actions: [
            submitButton('확인',()=>Navigator.of(context).pop())
          ],
        );
      },
    );
  }

  Future<void> submit() async {
    if (_selectedInterest != null) {
      Provider.of<ApplicationState>(context, listen: false).setData4(interests[_selectedInterest!]);
      await Provider.of<ApplicationState>(context, listen: false).createUserData();
      await showCompletion();
      context.go("/");
    } else {
      // Handle case when no interest is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('관심사를 선택해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: ColorStyle.bgColor1,
        title: const Text('관심사 설문조사'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: backBtn(() => context.go("/login/signup2")),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '당신의 관심사는 무엇인가요?',
              style: MyTextStyles.titleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: interests.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedInterest == index
                            ? ColorStyle.mainColor1
                            : ColorStyle.bgColor2,
                        side: const BorderSide(color: ColorStyle.mainColor1),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedInterest = index;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            _selectedInterest == index
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _selectedInterest == index
                                ? Colors.white
                                : ColorStyle.mainColor1,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            interests[index],
                            style: _selectedInterest == index
                                ? MyTextStyles.selectedTextStyle
                                : MyTextStyles.selectTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            submitButton('완료', submit)
          ],
        ),
      ),
    );
  }
}
