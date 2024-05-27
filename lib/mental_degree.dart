import 'package:flutter/material.dart';
import 'package:insideout/mainpage.dart';
class MentalDegree extends StatefulWidget {
  const MentalDegree({super.key});

  @override
  State<MentalDegree> createState() => _MentalDegreeState();
}

class _MentalDegreeState extends State<MentalDegree> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(30)),

            ),
            width: 50,
            height: 50,
          ),
          SizedBox(height: 20,),
          Text('유저 이름',style: TextStyle(fontSize: 20),),
          SizedBox(height: 20,),
          Expanded(child: ListView(
            children: [
              Option(Text('현재 멘탈 지수')),
              Option(Text('멘탈지수 그래프')),
              Option(Text('성실도 기반 그래프')),
            ],
          ))
        ],
      ),
    );
  }
}
