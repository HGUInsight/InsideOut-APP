import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../style.dart';

class SignUpSecond extends StatefulWidget {
  const SignUpSecond({super.key});

  @override
  State<SignUpSecond> createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<SignUpSecond> {
  bool hasDisability = false;
  bool _checkboxError = false;
  bool _typeError = false;
  String severity = '중증';
  String? disabilityType;
  List<String> disabilityTypes = [
    '지체장애',
    '호흡기장애',
    '언어장애',
    '심장장애',
    '간장애',
    '안면장애',
    '뇌전증장애'
  ];

  void submit() {
    if (hasDisability) {
      _typeError = disabilityType == null || disabilityType!.isEmpty;
    } else {
      _typeError = false;
    }

    if (!_typeError) {
      if (hasDisability) {
        Provider.of<ApplicationState>(context, listen: false)
            .setData3(disabilityType, severity);
      } else {
        Provider.of<ApplicationState>(context, listen: false)
            .setData3("none", "none");
      }
      Provider.of<ApplicationState>(context, listen: false).showUserData();
      context.go('/login/signup3');
    }

    setState(() {
      _checkboxError = false;
    });
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
        title: Text('장애 여부'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: backBtn(() => context.go("/login/signup1")),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    activeColor: ColorStyle.mainColor1,
                    title: Text('있음'),
                    value: hasDisability,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        hasDisability = value ?? false;
                        _checkboxError = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: ColorStyle.mainColor1,
                    title: Text('아니요'),
                    value: !hasDisability,
                    onChanged: (bool? value) {
                      setState(() {
                        hasDisability = !(value ?? true);
                        _checkboxError = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_checkboxError)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Text(
                  '장애 여부를 선택하세요.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 16.0),
            if (hasDisability) ...[
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('중증'),
                      leading: Radio<String>(
                        activeColor: ColorStyle.mainColor1,
                        value: '중증',
                        groupValue: severity,
                        onChanged: (String? value) {
                          setState(() {
                            severity = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('경증'),
                      leading: Radio<String>(
                        activeColor: ColorStyle.mainColor1,
                        value: '경증',
                        groupValue: severity,
                        onChanged: (String? value) {
                          setState(() {
                            severity = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('유형'),
              DropdownButtonFormField<String>(
                value: disabilityType,
                hint: const Text('유형을 선택하세요'),
                onChanged: (String? newValue) {
                  setState(() {
                    disabilityType = newValue;
                    _typeError = false;
                  });
                },
                items: disabilityTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (hasDisability && (value == null || value.isEmpty)) {
                    return '유형을 선택하세요.';
                  }
                  return null;
                },
              ),
              if (_typeError)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text(
                    '유형을 선택하세요.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 32.0),
            ],
            submitButton('다음', submit)
          ],
        ),
      ),
    );
  }
}
