import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpSecond extends StatefulWidget {
  const SignUpSecond({super.key});

  @override
  State<SignUpSecond> createState() => _SignUpSecondState();
}

class _SignUpSecondState extends State<SignUpSecond> {
  bool hasDisability = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장애 여부'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/login/signup1");
            // Handle back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text('있음'),
                    value: hasDisability,
                    onChanged: (bool? value) {
                      setState(() {
                        hasDisability = value ?? false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text('아니요'),
                    value: !hasDisability,
                    onChanged: (bool? value) {
                      setState(() {
                        hasDisability = !(value ?? true);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (hasDisability) ...[
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('중증'),
                      leading: Radio<String>(
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
              DropdownButton<String>(
                value: disabilityType,
                hint: Text('유형을 선택하세요'),
                onChanged: (String? newValue) {
                  setState(() {
                    disabilityType = newValue;
                  });
                },
                items: disabilityTypes
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 32.0),
            ],
            ElevatedButton(
              onPressed: () {
                context.go('/login/signup3');
                // Handle the next action
              },
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
