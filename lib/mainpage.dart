import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/app_state.dart';
import 'package:insideout/style.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Widget emptyStat(Function func) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: ColorStyle.mainColor2, // Background color of the container
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: ColorStyle.mainColor1, width: 1.0),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacer(),
        Text(
          '투두 리스트를 위한 멘탈 설문조사를 진행해주세요.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        ElevatedButton(
          onPressed: () {
            func();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyle.mainColor1, // Background color
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('설문 응답하기', style: MyTextStyles.buttonTextStyle),
        ),
      ],
    ),
  );
}

class _MainPageState extends State<MainPage> {
  List<bool> _todoChecked = [];
  List<String> _todoTitles = [];
  QuerySnapshot? querySnapshot; // Define querySnapshot at class level

  @override
  void initState() {
    super.initState();
    fetchTodoList();
  }

  Future<void> fetchTodoList() async {
    querySnapshot = await FirebaseFirestore.instance
        .collection('todolist')
        .doc(Provider.of<ApplicationState>(context, listen: false).uid)
        .collection('todo1')
        .get();

    List<bool> checkedList = [];
    List<String> titleList = [];

    querySnapshot?.docs.forEach((doc) {
      checkedList.add(doc['done']);
      titleList.add(doc['title']);
    });

    setState(() {
      _todoChecked = checkedList;
      _todoTitles = titleList;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        backgroundColor: ColorStyle.bgColor1,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat.yMMMMd('ko_KR').format(DateTime.now()),
            style: TextStyle(color: Colors.grey),
          ),
        ),
        leadingWidth: 200,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_alert_sharp, color: Colors.grey),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Lottie.asset('assets/egg_ani.json'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${appState.user.name}님, 환영합니다!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red),
                        Text(
                          ' 내 멘탈지수: 80',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorStyle.impactColor2, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '투두리스트: ${_todoTitles.length} | 남은 리스트: ${_todoChecked.where((checked) => !checked).length}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: _todoChecked.isNotEmpty
                  ? ListView.builder(
                itemCount: _todoChecked.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(_todoTitles[index]),
                    value: _todoChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _todoChecked[index] = value!;
                        // Update Firestore
                        FirebaseFirestore.instance
                            .collection('todolist')
                            .doc(Provider.of<ApplicationState>(context, listen: false).uid)
                            .collection('todo1')
                            .doc(querySnapshot?.docs[index].id)
                            .update({'done': value});
                      });
                    },
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    secondary: _todoChecked[index]
                        ? Icon(Icons.check_circle, color: Colors.blue)
                        : Icon(Icons.radio_button_unchecked,
                        color: Colors.grey),
                  );
                },
              )
                  : emptyStat(() => context.go('/test')),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'ABOUT ME',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    context.go("/checklist");
                  },
                  child: Column(
                    children: [
                      Text('체크리스트 성공률',
                          style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.7,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          Text(
                            '70',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text('관심사', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Icon(Icons.group, size: 40, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(appState.user.interest,
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
