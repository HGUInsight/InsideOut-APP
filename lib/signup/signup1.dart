import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpFirst extends StatefulWidget {
  const SignUpFirst({super.key});

  @override
  State<SignUpFirst> createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  bool isChecked = false;
  bool notChecked = false;
  String? selectedCenter;
  DateTime? selectedDate;
  final List<String> centers = [
    '센터 1',
    '센터 2',
    '센터 3',
    '센터 4',
    '센터 5',
    '센터 6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text('네'),
              value: isChecked,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false;
                  notChecked = false;
                });
              },
            ),
            if (isChecked) ...[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '센터 선택',
                  border: OutlineInputBorder(),
                ),
                items: centers.map((center) {
                  return DropdownMenuItem<String>(
                    value: center,
                    child: Text(center),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCenter = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '입소일',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: selectedDate != null
                      ? '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}'
                      : '',
                ),
              ),
            ],
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('아니요'),
              value: notChecked,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  notChecked = value ?? true;
                  isChecked = false;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // 다음 버튼 누를 때의 동작
                context.go("/login/signup2");
              },
              child: Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
