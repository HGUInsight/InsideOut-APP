import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insideout/app_state.dart';
import 'package:insideout/avatar.dart';
import 'package:insideout/main.dart';
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
      color: ColorStyle.mainColor2,
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
            backgroundColor: ColorStyle.mainColor1,
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

void _showInterestSelectionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return InterestSelectionModal();
    },
  );
}

class _MainPageState extends State<MainPage> {
  List<bool> _todoChecked = [];
  List<String> _todoTitles = [];
  QuerySnapshot? querySnapshot;
  double _checklistSuccessRate = 0.0;
  late Stream<QuerySnapshot> _todoStream;

  @override
  void initState() {
    super.initState();
    fetchTodoList();
    setupTodoStream();
  }

  void setupTodoStream() {
    var appState = Provider.of<ApplicationState>(context, listen: false);
    var uid = appState.uid;

    DateTime startOfDay = DateTime.now().toUtc().subtract(Duration(
      hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: DateTime.now().second,
      milliseconds: DateTime.now().millisecond,
      microseconds: DateTime.now().microsecond,
    ));
    DateTime endOfDay =
    startOfDay.add(Duration(hours: 23, minutes: 59, seconds: 59));

    _todoStream = FirebaseFirestore.instance
        .collection('todolist')
        .doc(uid)
        .collection('todo1')
        .where('datetime', isGreaterThanOrEqualTo: startOfDay)
        .where('datetime', isLessThanOrEqualTo: endOfDay)
        .snapshots();

    _todoStream.listen((snapshot) {
      querySnapshot = snapshot;
      List<bool> checkedList = [];
      List<String> titleList = [];

      snapshot.docs.forEach((doc) {
        checkedList.add(doc['done']);
        titleList.add(doc['title']);
      });

      setState(() {
        _todoChecked = checkedList;
        _todoTitles = titleList;
      });

      calculateChecklistSuccessRate();
    });
  }

  Future<void> fetchTodoList() async {
    var appState = Provider.of<ApplicationState>(context, listen: false);
    var uid = appState.uid;

    DateTime startOfDay = DateTime.now().toUtc().subtract(Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
        milliseconds: DateTime.now().millisecond,
        microseconds: DateTime.now().microsecond));
    DateTime endOfDay =
    startOfDay.add(Duration(hours: 23, minutes: 59, seconds: 59));

    querySnapshot = await FirebaseFirestore.instance
        .collection('todolist')
        .doc(uid)
        .collection('todo1')
        .where('datetime', isGreaterThanOrEqualTo: startOfDay)
        .where('datetime', isLessThanOrEqualTo: endOfDay)
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

    calculateChecklistSuccessRate();
  }

  Future<void> calculateChecklistSuccessRate() async {
    var appState = Provider.of<ApplicationState>(context, listen: false);
    var uid = appState.uid;

    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1).toUtc();
    DateTime endOfMonth = DateTime(now.year, now.month + 1, 1)
        .subtract(Duration(days: 1))
        .toUtc();

    QuerySnapshot monthlySnapshot = await FirebaseFirestore.instance
        .collection('todolist')
        .doc(uid)
        .collection('todo1')
        .where('datetime', isGreaterThanOrEqualTo: startOfMonth)
        .where('datetime', isLessThanOrEqualTo: endOfMonth)
        .get();

    int totalTasks = monthlySnapshot.size;
    int completedTasks =
        monthlySnapshot.docs.where((doc) => doc['done'] == true).length;

    setState(() {
      _checklistSuccessRate =
      totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;
    });
  }

  Icon _getInterestIcon(String interest) {
    switch (interest) {
      case '취업':
        return Icon(Icons.work, size: 40, color: ColorStyle.mainColor1);
      case '공동체':
        return Icon(Icons.group, size: 40, color: ColorStyle.mainColor1);
      case '인간관계':
        return Icon(Icons.people, size: 40, color: ColorStyle.mainColor1);
      case '관심사 1':
        return Icon(Icons.star, size: 40, color: ColorStyle.mainColor1);
      case '관심사 2':
        return Icon(Icons.favorite, size: 40, color: ColorStyle.mainColor1);
      default:
        return Icon(Icons.help, size: 40, color: ColorStyle.mainColor1);
    }
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
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: ColorStyle.mainColor1,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                DateFormat.yMMMMd('ko_KR').format(DateTime.now()),
                style: TextStyle(color: ColorStyle.mainColor1),
              ),
            ],
          ),
        ),
        leadingWidth: 200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpandedAvatarScreen1(),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'avatar',
                    child: CircleAvatar(
                      radius: 30,
                      child: Lottie.asset('assets/egg.json'),
                    ),
                  ),
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
                          ' 내 멘탈지수: ${appState.mental}',
                          style: TextStyle(color: Colors.red),
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
                    border:
                    Border.all(color: ColorStyle.mainColor1, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '투두리스트: ${_todoTitles.length} | 남은 리스트: ${_todoChecked.where((checked) => !checked).length}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorStyle.mainColor1),
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
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ColorStyle.mainColor1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        _todoTitles[index],
                        style: TextStyle(color: ColorStyle.mainColor1),
                      ),
                      leading: Icon(
                        _todoChecked[index]
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: _todoChecked[index]
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          _todoChecked[index] = !_todoChecked[index];
                          FirebaseFirestore.instance
                              .collection('todolist')
                              .doc(Provider.of<ApplicationState>(context,
                              listen: false)
                              .uid)
                              .collection('todo1')
                              .doc(querySnapshot?.docs[index].id)
                              .update({'done': _todoChecked[index]});
                        });
                      },
                    ),
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: ColorStyle.bgColor2,
                      border:
                      Border.all(color: ColorStyle.mainColor1, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.go("/checklist");
                      },
                      child: Column(
                        children: [
                          Text('체크리스트 성공률',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 10),
                          Container(
                            width: 70, // 아이콘 크기와 동일한 값으로 수정
                            height: 70, // 아이콘 크기와 동일한 값으로 수정
                            decoration: BoxDecoration(
                              color: ColorStyle.bgColor2,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: _checklistSuccessRate,
                                    strokeWidth: 7,
                                    backgroundColor: Colors.grey[200],
                                    valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        ColorStyle.mainColor1),
                                  ),
                                ),
                                Text(
                                  '${(_checklistSuccessRate * 100).toInt()}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorStyle.mainColor1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text('성공률',
                              style: TextStyle(color: ColorStyle.mainColor1)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: ColorStyle.bgColor2,
                      border:
                      Border.all(color: ColorStyle.mainColor1, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showInterestSelectionModal(context);
                      },
                      child: Column(
                        children: [
                          Text('관심사', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 10),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: ColorStyle.bgColor2,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: _getInterestIcon(appState.user.interest),
                          ),
                          SizedBox(height: 10),
                          Text(appState.user.interest,
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InterestSelectionModal extends StatelessWidget {
  final List<String> interests = ['취업', '공동체', '인간관계', '관심사 1', '관심사 2'];

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<ApplicationState>(context, listen: false);
    var uid = appState.uid;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: interests.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(interests[index]),
            onTap: () async {
              // 선택한 관심사를 Firestore에 업데이트
              QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                  .collection('user')
                  .where('uid', isEqualTo: uid)
                  .get();
              if (userSnapshot.docs.isNotEmpty) {
                String docId = userSnapshot.docs.first.id;
                FirebaseFirestore.instance
                    .collection('user')
                    .doc(docId)
                    .update({'interest': interests[index]}).then((_) {
                  appState.user.interest = interests[index];
                  appState.notifyListeners();
                  debugPrint('interest changed : ${appState.user.interest}');
                  // 업데이트 후 모달 닫기
                  Navigator.pop(context);
                }).catchError((error) {
                  // 에러 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('업데이트에 실패했습니다: $error')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('사용자 정보를 찾을 수 없습니다.')),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class ExpandedAvatarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      body: Center(
        child: Hero(
          tag: 'avatar',
          child: CircleAvatar(
            radius: 100,
            child: Lottie.asset('assets/egg_ani.json'),
          ),
        ),
      ),
    );
  }
}
