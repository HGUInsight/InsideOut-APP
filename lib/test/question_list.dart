import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insideout/test/test_card.dart';
import '../style.dart';

class QuestionList extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> questions;
  final List<int?> selectedOptions;
  final String appBarTitle;
  final Function(int, int?) onOptionSelected;

  QuestionList({
    required this.questions,
    required this.selectedOptions,
    required this.appBarTitle,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        var doc = questions[index];
        var question = doc['problem'];
        var options = getOptionsBasedOnCategory(appBarTitle, doc);

        return QuestionCard(
          question: question,
          options: options,
          selectedOption: selectedOptions[index],
          onChanged: (value) {
            onOptionSelected(index, value);
          },
        );
      },
    );
  }

  List<String> getOptionsBasedOnCategory(
      String category, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
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
        if (doc.data().containsKey('check5')) {
          options.add(doc['check5'].toString());
        }
        break;
    }
    return options;
  }
}
