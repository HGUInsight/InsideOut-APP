import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../style.dart';

class TestForm extends StatefulWidget {
  const TestForm({super.key});

  @override
  State<TestForm> createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  List<int?> selectedOptions = [];
  int pageNum = 1;
  int totalCount = 0;
  bool showValidationError = false;
  QuerySnapshot? querySnapshot;

  Future<int> getTestCount() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('test')
          .doc('z7ZmCEhn2ARYwQQ26Gsk')
          .get();
      if (document.exists && document.data() != null) {
        return (document.data() as Map<String, dynamic>)['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting test count: $e');
      return 0;
    }
  }

  Future<void> loadPreviousAnswers() async {
    var appState = context.read<ApplicationState>();
    var userTestRef = FirebaseFirestore.instance
        .collection('userTestData')
        .doc(appState.user.id)
        .collection('page$pageNum');

    var snapshot = await userTestRef.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        for (var doc in snapshot.docs) {
          var index = querySnapshot!.docs.indexWhere((d) => d.id == doc.id);
          if (index != -1) {
            selectedOptions[index] = doc['selectedOption'];
          }
        }
      });
    }
  }

  void showExitWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorStyle.bgColor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '정말 그만 두시겠습니까?',
                style: TextStyle(
                    color: ColorStyle.impactColor3,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.mainColor2,
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(color: ColorStyle.mainColor1),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/test');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.mainColor1,
                    ),
                    child: Text(
                      '예',
                      style: TextStyle(color: ColorStyle.mainColor2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showSubmissionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorStyle.bgColor1,
          title: Text(
            '유저님의 멘탈지수는',
            style: TextStyle(color: ColorStyle.mainColor1),
          ),
          content: Text(
            '100',
            style: TextStyle(color: ColorStyle.mainColor1),
          ),
          actions: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyle.mainColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(color: ColorStyle.bgColor1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> submitData() async {
    var appState = context.read<ApplicationState>();
    var batch = FirebaseFirestore.instance.batch();
    var userTestRef = FirebaseFirestore.instance
        .collection('userTestData')
        .doc(appState.user.id);

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] != null) {
        var questionDoc = querySnapshot?.docs[i];
        if (questionDoc != null) {
          var userTestQuestionRef =
          userTestRef.collection('page$pageNum').doc(questionDoc.id);
          batch.set(
            userTestQuestionRef,
            {
              'pageNum': pageNum,
              'selectedOption': selectedOptions[i],
            },
            SetOptions(merge: true),
          );
        }
      }
    }

    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        backgroundColor: ColorStyle.bgColor1,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: () {
            showExitWarningDialog(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<int>(
          future: getTestCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              totalCount = snapshot.data ?? 0;
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('test')
                    .doc('z7ZmCEhn2ARYwQQ26Gsk')
                    .collection("page$pageNum")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available'));
                  } else {
                    querySnapshot = snapshot.data;
                    var docs = snapshot.data!.docs;
                    if (selectedOptions.length != docs.length) {
                      selectedOptions =
                      List<int?>.filled(docs.length, null);
                      loadPreviousAnswers(); // Load previous answers here
                    }
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: pageNum / totalCount,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorStyle.mainColor1),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '※ 아래의 문항을 잘 살펴보고 자신에게 해당되는 곳에 체크해 보세요',
                          style: TextStyle(
                              fontSize: 14, color: ColorStyle.mainColor1),
                        ),
                        SizedBox(height: 16),
                        if (showValidationError)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              '모든 문항을 체크해주세요.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              var doc = docs[index];
                              var question = doc['problem'];
                              var options = [
                                doc['check1'].toString(),
                                doc['check2'].toString(),
                                doc['check3'].toString(),
                                doc['check4'].toString()
                              ];
                              return _buildQuestionCard(
                                question: question,
                                options: options,
                                selectedOption: selectedOptions[index],
                                onChanged: (value) {
                                  setState(() {
                                    selectedOptions[index] = value;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            if (pageNum > 1) // Only show if pageNum > 1
                              _navigationButton('이전', () {
                                if (pageNum > 1) {
                                  setState(() {
                                    pageNum--;
                                    selectedOptions = [];
                                    showValidationError = false;
                                  });
                                }
                              }, Colors.white, ColorStyle.mainColor1),
                            if (pageNum > 1) SizedBox(width: 8),
                            Spacer(), // Pushes the 다음 button to the right
                            _navigationButton(
                              pageNum / totalCount == 1 ? '제출' : '다음',
                                  () {
                                if (selectedOptions.contains(null)) {
                                  setState(() {
                                    showValidationError = true;
                                  });
                                } else {
                                  showValidationError = false;
                                  submitData().then((_) {
                                    if (pageNum / totalCount == 1) {
                                      showSubmissionModal(context);
                                    } else {
                                      if (pageNum < totalCount) {
                                        setState(() {
                                          pageNum++;
                                          selectedOptions = [];
                                        });
                                      }
                                    }
                                  });
                                }
                              },
                              ColorStyle.mainColor1,
                              ColorStyle.bgColor2,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required String question,
    required List<String> options,
    required int? selectedOption,
    required ValueChanged<int?> onChanged,
  }) {
    return Card(
      color: ColorStyle.bgColor1,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: ColorStyle.mainColor1, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18, color: ColorStyle.mainColor1),
            ),
            SizedBox(height: 16),
            for (int i = 0; i < options.length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                title: Text(options[i], style: TextStyle(color: ColorStyle.mainColor1)),
                onChanged: onChanged,
                activeColor: ColorStyle.mainColor1,
              ),
          ],
        ),
      ),
    );
  }

  Widget _navigationButton(
      String text, VoidCallback onPressed, Color backgroundColor, Color textColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: ColorStyle.mainColor1, width: 1),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: textColor),
      ),
    );
  }
}
