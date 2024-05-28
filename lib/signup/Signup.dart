import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _gender = '';
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = "02 / 10 / 2003";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Example'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: '아이디',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  suffixIcon: Icon(Icons.visibility),
                ),
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이름',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '휴대폰번호',
                ),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: '생년월일',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
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
                  Expanded(
                    child: ListTile(
                      title: const Text('기타'),
                      leading: Radio<String>(
                        value: '기타',
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    /*if (_formKey.currentState!.validate()) {
                      debugPrint("empty");
                      // Process data
                    }*/
                    context.go("/login/signup1");
                  },
                  child: Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
