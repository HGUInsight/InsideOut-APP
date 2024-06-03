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
  void initState() {
    // TODO: implement initState
    super.initState();
    //Provider.of<ApplicationState>(context, listen: false).showUserData();
  }

  void submit() {
    if (isChecked == true) {
      Provider.of<ApplicationState>(context, listen: false)
          .setData2(selectedCenter, selectedDate);
      Provider.of<ApplicationState>(context, listen: false).showUserData();
    } else {
      Provider.of<ApplicationState>(context, listen: false)
          .setData2("none", DateTime(1000));
      Provider.of<ApplicationState>(context, listen: false).showUserData();
      // Handle the '아니요' case if needed
    }
    // 다음 버튼 누를 때의 동작
    context.go("/login/signup2");
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
                        ? '${selectedDate!.month.toString().padLeft(2, '0')} / ${selectedDate!.day.toString().padLeft(2, '0')} / ${selectedDate!.year}'
                        : '',
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
    );
  }
}
