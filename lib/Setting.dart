import 'package:flutter/material.dart';

import 'mainpage.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            '설정',
            style: TextStyle(
              fontSize: 30,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '유저 이름',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(child: ListView(
            children: [
              Option(Text('연결된 센터')),
              Option(Text('알림설정')),
              Option(Text('나머지 설정들')),
            ],
          ))
        ],
      ),
    );
  }
}
