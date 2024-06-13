import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../app_state.dart';
import '../style.dart';

class TestForm extends StatefulWidget {
  const TestForm({Key? key});

  @override
  State<TestForm> createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  List<int?> selectedOptions = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> questions = [];
  int pageNum = 1;
  int totalCount = 0;
  bool showValidationError = false;
  QuerySnapshot<Map<String, dynamic>>? querySnapshot;
  String appBarTitle = '';
  late AutoScrollController _controller;
  late FocusNode submitButtonFocusNode;

  Future<void> getCategory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('test')
          .doc('z7ZmCEhn2ARYwQQ26Gsk')
          .collection("page$pageNum")
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          appBarTitle = data['category'] ?? '';
        });
      } else {
        setState(() {
          appBarTitle = '';
        });
      }
    } catch (e) {
      print('Error getting category: $e');
      setState(() {
        appBarTitle = '';
      });
    }
  }

  Future<int> getTestCount() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore.instance
          .collection('test')
          .doc('z7ZmCEhn2ARYwQQ26Gsk')
          .get();
      if (document.exists && document.data() != null) {
        var data = document.data() as Map<String, dynamic>;
        return data['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting test count: $e');
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AutoScrollController(); // Initialize AutoScrollController
    submitButtonFocusNode = FocusNode();

    // Fetch category when the widget initializes
    getCategory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var appState = context.read<ApplicationState>();
      appState.resetTotalScore();
    });
  }

  @override
  void dispose() {
    submitButtonFocusNode.dispose();
    _controller.dispose(); // AutoScrollController dispose 추가
    super.dispose();
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
                  fontWeight: FontWeight.bold,
                ),
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

  void showSubmissionModal(BuildContext context, int score) {
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
            score.toString(),
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
    var userTestRef = FirebaseFirestore.instance.collection('result').doc(appState.uid);
    Map<int, String> category = {
      1: "정신질환(비전트레이닝 센터)",
      2: "우울증(PHQ-9)",
      3: "스트레스(PSS)",
      4: "불안장애(GAD-7)"
    };

    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i] != null) {
        var questionDoc = querySnapshot?.docs[i];
        print("Adding score: ${selectedOptions[i]}");  // Debug print

        appState.addTotalScore(selectedOptions[i]!);

        if (questionDoc != null) {
          var userTestQuestionRef = userTestRef.collection('page$pageNum').doc(questionDoc.id);
          batch.set(
            userTestQuestionRef,
            {
              'choice': pageNum,
              'number': selectedOptions[i],
              'category': category[pageNum]
            },
            SetOptions(merge: true),
          );
        }
      }
    }

    await batch.commit();
    print("Total score after submission: ${appState.totalScore}");  // Debug print
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.bgColor1,
      appBar: AppBar(
        backgroundColor: ColorStyle.bgColor1,
        elevation: 0,
        title: Text(
          appBarTitle,
          style: MyTextStyles.titleTextStyle2,
        ),
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
                    querySnapshot =
                    snapshot.data as QuerySnapshot<Map<String, dynamic>>;
                    var docs = querySnapshot!.docs;

                    if (selectedOptions.length != docs.length) {
                      selectedOptions = List<int?>.filled(docs.length, null);
                    }

                    questions = docs
                        .where((doc) =>
                    selectedOptions[docs.indexOf(doc)] == null)
                        .toList();

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
                          child: questions.isNotEmpty
                              ? ListView.builder(
                            controller: _controller, // ScrollController 설정
                            itemCount: questions.length,
                            itemBuilder: (context, index) {
                              var doc = questions[index];
                              var question = doc['problem'];
                              var options =
                              getOptionsBasedOnCategory(
                                  appBarTitle, doc);

                              return AutoScrollTag(
                                key: ValueKey(index),
                                controller: _controller,
                                index: index,
                                child: _buildQuestionCard(
                                  question: question,
                                  options: options,
                                  selectedOption:
                                  selectedOptions[docs.indexOf(doc)],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOptions[
                                      docs.indexOf(doc)] = value;
                                    });
                                  },
                                ),
                              );
                            },
                          )
                              : Center(
                            child: Text(
                              '모든 문항을 완료했습니다.',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: ColorStyle.mainColor1),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            if (pageNum > 1)
                              _navigationButton(
                                '이전',
                                    () {
                                  setState(() {
                                    if (pageNum > 1) {
                                      pageNum--;
                                      selectedOptions = [];
                                      getCategory(); // Update category on page change
                                    }
                                  });
                                },
                                Colors.white,
                                ColorStyle.mainColor1,
                              ),
                            if (pageNum > 1) SizedBox(width: 8),
                            Spacer(),
                            _navigationButton(
                              pageNum / totalCount == 1 ? '제출' : '다음',
                                  () {
                                if (selectedOptions.contains(null)) {
                                  setState(() {
                                    showValidationError = true;
                                  });
                                } else {
                                  showValidationError = false;
                                  submitData().then((_) async {
                                    if (pageNum / totalCount == 1) {
                                      var appState = context.read<ApplicationState>();
                                      int score = appState.calculateMentalScore();
                                      await appState.saveMentalScore(score);
                                      appState.setMental(score);
                                      showSubmissionModal(context, score);
                                    } else {
                                      if (pageNum < totalCount) {
                                        setState(() {
                                          pageNum++;
                                          selectedOptions = context
                                              .read<ApplicationState>()
                                              .getSelectedOptions(pageNum);
                                          getCategory(); // Update category on page change
                                        });
                                      }
                                    }
                                  });
                                }
                              },
                              ColorStyle.mainColor1,
                              ColorStyle.bgColor2,
                              submitButtonFocusNode,
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

  List<String> getOptionsBasedOnCategory(String category,
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    List<String> options;
    switch (category) {
      case '정신질환(비전트레이닝 센터)':
        options = ['없음', '가끔', '자주', '거의 항상'];
        break;
      case '우울증(PHQ-9)':
        options = ['전혀 없음', '며칠 동안', '1주일 이상', '거의 매일'];
        break;
      case '스트레스(PSS)':
        options = ['전혀 없음', '거의 없음', '때때로 있음', '자주 있음', '매우 있음'];
        break;
      case '불안장애(GAD-7)':
        options = [
          '전혀 방해 받지 않았다',
          '며칠 동안 방해 받았다',
          '2주중 절반 이상 방해 받았다',
          '거의 매일 방해 받았다'
        ];
        break;
      default:
        options = [
          doc['check1'].toString(),
          doc['check2'].toString(),
          doc['check3'].toString(),
          doc['check4'].toString()
        ];
        if (pageNum == 3 && doc.data().containsKey('check5')) {
          options.add(doc['check5'].toString());
        }
        break;
    }
    return options;
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, i) {
                return RadioListTile<int>(
                  value: i,
                  groupValue: selectedOption,
                  title: Text(
                    options[i],
                    style: TextStyle(color: ColorStyle.mainColor1),
                  ),
                  onChanged: (value) {
                    onChanged(value);
                    setState(() {
                      selectedOptions[selectedOptions.indexOf(null)] = value;
                      questions.removeWhere((q) => q['problem'] == question);
                      print("Selected options: $selectedOptions");  // Debug print
                    });
                  },
                  activeColor: ColorStyle.mainColor1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _navigationButton(String text, VoidCallback onPressed,
      Color backgroundColor, Color textColor, [FocusNode? focusNode]) {
    return ElevatedButton(
      onPressed: onPressed,
      focusNode: focusNode,
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
