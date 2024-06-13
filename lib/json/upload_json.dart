import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> uploadJsonToFirestore() async {
  debugPrint('uploading json start...');
  // JSON 파일 읽기
  String jsonString = await rootBundle.loadString('lib/json/gad.json');
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // 기본 문서 참조 생성
  DocumentReference baseDocRef = FirebaseFirestore.instance
      .collection('test')
      .doc('z7ZmCEhn2ARYwQQ26Gsk');

  // JSON 데이터의 각 페이지 반복 처리
  for (String collectionName in jsonData.keys) {
    Map<String, dynamic> collectionData = jsonData[collectionName];

    // 컬렉션 내 각 문서 반복 처리
    for (String documentId in collectionData.keys) {
      Map<String, dynamic> documentData = collectionData[documentId];

      // 자동 생성된 ID로 서브 컬렉션에 문서 추가
      await baseDocRef.collection(collectionName).add(documentData);
    }
  }
}
