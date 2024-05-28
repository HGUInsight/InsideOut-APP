import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  List<bool> _todoChecked = [false, false, false, false, false];

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('유저님, 환영합니다!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('💗 멘탈지수', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('To Do List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _todoChecked.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text('할 일 ${index + 1}'),
                    value: _todoChecked[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _todoChecked[index] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('ABOUT ME', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    context.go("/checklist");
                  },
                  child: Column(
                    children: [
                      Text('체크리스트 성공률', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.7,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          Text('70', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      color: Colors.grey[300],
                      child: Icon(Icons.mail, size: 40, color: Colors.grey),
                    ),
                    Text('공동체')
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
