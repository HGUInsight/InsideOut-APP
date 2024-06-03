import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/app_state.dart';
import 'package:insideout/style.dart';
import 'package:provider/provider.dart';

import '../auth/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

Widget backBtn(Function() func) {
  return CircleAvatar(
    backgroundColor: ColorStyle.mainColor1,
    child: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: ColorStyle.bgColor2,
      ),
      onPressed: () {
        func();
        // Handle back action
      },
    ),
  );
}

Widget submitButton(String text, Function() func) {
  return SizedBox(
    child: ElevatedButton(
      onPressed: () {
        debugPrint("function: $func");
        func(); // 여기를 수정해서 func가 실행되도록 합니다.
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
    ),
  );
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _gender = '';
  final TextEditingController _dateController = TextEditingController();

  TextEditingController idController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = "02 / 10 / 2003";
  }

  Widget CustomTextFormField(
      {required TextEditingController controller,
      required String labelText,
      bool? obscureText,
      Widget? suffixIcon,
      TextInputType? keyboardType,
      bool? readOnly}) {
    readOnly ??= false;
    obscureText ??= false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5.0),
        Text(labelText),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            suffixIcon: suffixIcon,
          ),
          keyboardType: keyboardType,
          readOnly: readOnly,
        ),
      ],
    );
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      debugPrint("empty");
      // Process data
    }
    var name = nameController.text;
    var gender = _gender;
    var enterDT = _dateController.text;
    var phone = phoneController.text;
    var pwd = pwdController.text;
    var id = idController.text;
    debugPrint("Name: $name, Gender: $gender, Enter Date: $enterDT, Phone: $phone, Password: $pwd, ID: $id");
    Provider.of<ApplicationState>(context, listen: false).setData1(id, name, pwd, phone, enterDT, gender);
    //Provider.of<ApplicationState>(context, listen: false).insertUser1(id,name,phone,pwd,enterDT,gender);

    Provider.of<ApplicationState>(context, listen: false).showUserData();
    context.go("/login/signup1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: ColorStyle.bgColor1,
        leading: Padding(
            padding: const EdgeInsets.all(8.0), child: backBtn(() => null)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: idController,
                  labelText: '아이디',
                  obscureText: false,
                  suffixIcon: SizedBox(),
                ),
                CustomTextFormField(
                  controller: pwdController,
                  labelText: '비밀번호',
                  suffixIcon: Icon(Icons.visibility_outlined),
                  obscureText: true,
                ),
                CustomTextFormField(
                  controller: nameController,
                  labelText: '이름',
                ),
                CustomTextFormField(
                  controller: phoneController,
                  labelText: '휴대폰번호',
                  keyboardType: TextInputType.phone,
                ),
                CustomTextFormField(
                  controller: _dateController,
                  labelText: '생년월일',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2003, 2, 10),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              "${pickedDate.month.toString().padLeft(2, '0')} / ${pickedDate.day.toString().padLeft(2, '0')} / ${pickedDate.year}";
                        });
                      }
                    },
                  ),
                  readOnly: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text('성별'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('남'),
                        leading: Radio<String>(
                          activeColor: ColorStyle.mainColor1,
                          value: '남',
                          groupValue: _gender,
                          onChanged: (String? value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('여'),
                        leading: Radio<String>(
                          activeColor: ColorStyle.mainColor1,
                          value: '여',
                          groupValue: _gender,
                          onChanged: (String? value) {
                            setState(() {
                              _gender = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                submitButton('다음', submit), // 여기를 수정해서 함수가 호출되도록 함
              ],
            ),
          ),
        ),
      ),
    );
  }
}
