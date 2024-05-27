import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

Widget Option(Text text){
  return Card(
    child: ListTile(
      title: text,
    ),
  );
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(DateFormat.yMMMd().format(DateTime.now())),
        ),
        leadingWidth: 200,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add_alert_sharp))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  width: 60,
                  height: 60,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('어서오세요, 유저', style: TextStyle(fontSize: 20),),
                    Text('오늘 상태')
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView(
                children: [
                  Option(Text('내 멘탈지수, 관심 카테고리, 캘린더 - 완성도 표기')),
                  Option(Text('To Do 리스트')),
                  Option(Text('추천 컨텐츠')),
                  Option(Text('알림창 : 설문 조사하기\n일정지수에 도달하면 화면에 플로팅 아이콘 혹은 모달창으로 뜨게하기'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
