import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckList extends StatefulWidget {
  const CheckList({super.key});

  @override
  State<CheckList> createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _toDoItems = [];
  double _completionPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchMonthlyToDoItems();
  }

  void _fetchMonthlyToDoItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DateTime startOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    DateTime endOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0, 23, 59, 59);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('todolist')
        .doc(user.uid)
        .collection('todo1')
        .where('datetime', isGreaterThanOrEqualTo: startOfMonth)
        .where('datetime', isLessThanOrEqualTo: endOfMonth)
        .get();

    debugPrint("current uid : ${user.uid}");

    setState(() {
      _toDoItems = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // 문서 ID를 데이터에 추가하여 나중에 업데이트할 때 사용합니다.
        return data;
      }).toList();

      _completionPercentage = _calculateCompletionPercentage();
    });
  }

  void _fetchToDoItems(DateTime selectedDate) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('todolist')
        .doc(user.uid)
        .collection('todo1')
        .where('datetime', isGreaterThanOrEqualTo: startOfDay)
        .where('datetime', isLessThanOrEqualTo: endOfDay)
        .get();

    debugPrint("current uid : ${user.uid}");

    setState(() {
      _toDoItems = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // 문서 ID를 데이터에 추가하여 나중에 업데이트할 때 사용합니다.
        return data;
      }).toList();
    });
  }

  double _calculateCompletionPercentage() {
    if (_toDoItems.isEmpty) {
      return 0.0;
    }
    int completedTasks = _toDoItems.where((item) => item['done'] == true).length;
    return completedTasks / _toDoItems.length;
  }

  void _toggleCheck(int index) async {
    setState(() {
      _toDoItems[index]['done'] = !_toDoItems[index]['done'];
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('todolist')
        .doc(user.uid)
        .collection('todo1')
        .doc(_toDoItems[index]['id'])
        .update({'done': _toDoItems[index]['done']});

    setState(() {
      _completionPercentage = _calculateCompletionPercentage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이 달 성공률'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 13.0,
                  animation: true,
                  percent: _completionPercentage,
                  center: Text(
                    "${(_completionPercentage * 100).toStringAsFixed(1)}%",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.blue,
                  backgroundColor: Colors.grey[300]!,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                      });
                      _fetchMonthlyToDoItems();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                      });
                      _fetchMonthlyToDoItems();
                    },
                  ),
                ],
              ),
              TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2090, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchToDoItems(selectedDay);
                },
                calendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'To Do List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ToDoList(toDoItems: _toDoItems, toggleCheck: _toggleCheck),
            ],
          ),
        ),
      ),
    );
  }
}

class ToDoList extends StatelessWidget {
  final List<Map<String, dynamic>> toDoItems;
  final Function(int) toggleCheck;

  ToDoList({required this.toDoItems, required this.toggleCheck});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: toDoItems.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(
              toDoItems[index]['done'] ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.grey,
            ),
            title: Text(toDoItems[index]['title']),
            onTap: () => toggleCheck(index),
          ),
        );
      },
    );
  }
}
