import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../signup/Signup.dart';
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

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: () {
            // Close the screen
            context.go('/test');
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
                    var docs = snapshot.data!.docs;
                    if (selectedOptions.length != docs.length) {
                      selectedOptions = List<int?>.filled(docs.length,
                          null); // Initialize selectedOptions with null if not already done
                    }
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: pageNum / totalCount,
                          // Set the progress value as needed
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '※ 아래의 문항을 잘 살펴보고 자신에게 해당되는 곳에 체크해 보세요',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 16),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _navigationButton('이전', () {
                              // Handle previous button action
                              if (pageNum > 1) {
                                setState(() {
                                  pageNum--;
                                  selectedOptions =
                                      []; // Clear selectedOptions when changing page
                                });
                              }
                            }),
                            _navigationButton(
                              pageNum / totalCount == 1 ? '제출' : '다음',
                              () {
                                // Handle next button action
                                if (pageNum / totalCount == 1) {
                                  appState.insertTestData(
                                      pageNum, selectedOptions);
                                  context.go('/');
                                } else {
                                  if (pageNum < totalCount) {
                                    appState.insertTestData(
                                        pageNum, selectedOptions);
                                    setState(() {
                                      pageNum++;
                                      selectedOptions =
                                          []; // Clear selectedOptions when changing page
                                    });
                                  }
                                }
                              },
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
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            for (int i = 0; i < options.length; i++)
              RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                title: Text(options[i]),
                onChanged: onChanged,
                activeColor: Colors.blueGrey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _navigationButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
        minimumSize: Size(100, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
