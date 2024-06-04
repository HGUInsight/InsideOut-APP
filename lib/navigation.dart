import 'package:flutter/material.dart';
import 'package:insideout/Setting.dart';
import 'package:insideout/mainpage.dart';
import 'package:insideout/mental_degree.dart';
import 'package:insideout/style.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    MentalDegree(),
    Setting(),
  ];

  void _onItemTapped(int index) {
    // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      _selectedIndex = index;
      debugPrint(index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈화면',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket_outlined),
            label: '멘탈지수',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '마이페이지',
          ),
        ],
        selectedItemColor: ColorStyle.mainColor1,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        backgroundColor: ColorStyle.bgColor1,
        onTap: _onItemTapped,
      ),
    );
  }
}
