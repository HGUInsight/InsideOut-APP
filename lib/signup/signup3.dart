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
  final List<String> interests = ['취업', '공동체', '인간관계', '관심사 1', '관심사 2'];
  final List<IconData> interestIcons = [
    Icons.work,
    Icons.group,
    Icons.people,
    Icons.star,
    Icons.favorite,
    Icons.local_offer,
  ];

  Future<void> showCompletion() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorStyle.bgColor1,
          content: const Text(
            '계정 생성이\n완료되었습니다!',
            style: MyTextStyles.titleTextStyle,
          ),
          actions: [
            submitButton('확인', () => Navigator.of(context).pop())
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('관심사를 선택해주세요.')),
      );
    }
  }

  Widget backBtn(Function onPressed) {
    return CircleAvatar(
      backgroundColor: ColorStyle.mainColor1,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: ColorStyle.bgColor2,
        ),
        onPressed: onPressed as void Function()?,
      ),
    );
  }

  Widget submitButton(String text, Function func) {
    return ElevatedButton(
      onPressed: () => func(),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorStyle.mainColor1,
        minimumSize: const Size(200, 50), // Width and height of the button
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
            if (_selectedInterest != null)
              Column(
                children: [
                  Icon(
                    interestIcons[_selectedInterest!],
                    size: 100,
                    color: ColorStyle.mainColor1,
                  ),
                  Text(
                    interests[_selectedInterest!],
                    style: MyTextStyles.titleTextStyle,
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: interests.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: _selectedInterest == index
                              ? ColorStyle.mainColor1
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      tileColor: _selectedInterest == index
                          ? ColorStyle.mainColor1.withOpacity(0.2)
                          : ColorStyle.bgColor2,
                      leading: Icon(
                        interestIcons[index],
                        color: _selectedInterest == index
                            ? ColorStyle.mainColor1
                            : Colors.black,
                      ),
                      title: Text(
                        interests[index],
                        style: _selectedInterest == index
                            ? MyTextStyles.selectedTextStyle
                            : MyTextStyles.selectTextStyle,
                      ),
                      trailing: Radio<int>(
                        value: index,
                        groupValue: _selectedInterest,
                        activeColor: ColorStyle.mainColor1,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedInterest = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _selectedInterest = index;
                        });
                      },
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
