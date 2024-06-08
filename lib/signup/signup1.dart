import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../style.dart';
import '../auth/user.dart';
import '../app_state.dart';

class SignUpFirst extends StatefulWidget {
  const SignUpFirst({super.key});

  @override
  State<SignUpFirst> createState() => _SignUpFirstState();
}

class _SignUpFirstState extends State<SignUpFirst> {
  bool isChecked = false;
  bool notChecked = false;
  bool _checkboxError = false;
  bool _centerError = false;
  bool _dateError = false;
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submit() {
    setState(() {
      _checkboxError = !isChecked && !notChecked;
      _centerError = isChecked && (selectedCenter == null || selectedCenter!.isEmpty);
      _dateError = isChecked && selectedDate == null;
    });

    if (_formKey.currentState!.validate() && !_checkboxError && !_centerError && !_dateError) {
      if (isChecked) {
        Provider.of<ApplicationState>(context, listen: false)
            .setData2(selectedCenter, selectedDate);
      } else {
        Provider.of<ApplicationState>(context, listen: false)
            .setData2("none", DateTime(1000));
      }
      Provider.of<ApplicationState>(context, listen: false).showUserData();
      context.go("/login/signup2");
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: backBtn(() => context.go("/login/signup")),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "노숙인 센터에\n거주 중이신가요?",
                    style: MyTextStyles.titleTextStyle,
                  ),
                ),
                SizedBox(height: 20),
                CheckboxListTile(
                  title: Text('네'),
                  value: isChecked,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: ColorStyle.mainColor1,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                      notChecked = false;
                      _checkboxError = false;
                    });
                  },
                ),
                if (_checkboxError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text(
                      '센터 거주 여부를 선택하세요.',
                      style: TextStyle(color: Colors.red),
                    ),
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
                        _centerError = false;
                      });
                    },
                    validator: (value) {
                      if (isChecked && (value == null || value.isEmpty)) {
                        return '센터를 선택하세요.';
                      }
                      return null;
                    },
                  ),
                  if (_centerError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: Text(
                        '센터를 선택하세요.',
                        style: TextStyle(color: Colors.red),
                      ),
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
                          _dateError = false;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? '${selectedDate!.month.toString().padLeft(2, '0')} / ${selectedDate!.day.toString().padLeft(2, '0')} / ${selectedDate!.year}'
                          : '',
                    ),
                    validator: (value) {
                      if (isChecked && (selectedDate == null)) {
                        return '입소일을 선택하세요.';
                      }
                      return null;
                    },
                  ),
                  if (_dateError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                      child: Text(
                        '입소일을 선택하세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('아니요'),
                  activeColor: ColorStyle.mainColor1,
                  value: notChecked,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      notChecked = value ?? true;
                      isChecked = false;
                      _checkboxError = false;
                    });
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: submitButton('다음', submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
