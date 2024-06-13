import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'auth/user.dart';

class ApplicationState extends ChangeNotifier {
  UserData user =
      UserData("", "", "", "", "", "", DateTime.utc(1000), "", "", "", "");
  String uid = "";
  int mental = 0;
  int totalScore = 0;
  Map<int, List<int?>> selectedOptions = {};

  ApplicationState() {
    debugPrint('initializing...');
    init();
  }

  void resetTotalScore() {
    totalScore = 0;
    debugPrint("total score reset to 0");
    notifyListeners();
  }

  Future<void> setUID(userid) async {
    uid = userid;
    notifyListeners();
  }

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((event) {
      if (event != null) {
        uid = event.uid;
        getUserData();
      }
    });

    notifyListeners();
  }

  Future<void> setMental(int mentalNum) async {
    mental = mentalNum;
    notifyListeners();
  }

  List<MentalHealthData> mentalHealthDataList = [];

  Future<void> fetchMentalHealthData() async {
    List<String> pages = ['page1', 'page2', 'page3', 'page4'];
    Map<String, int> categorySums = {};
    for (String page in pages) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('result')
          .doc(uid)
          .collection(page)
          .get();

      for (var doc in querySnapshot.docs) {
        String category = doc['category'];
        int value = doc['number'];

        if (categorySums.containsKey(category)) {
          categorySums[category] = categorySums[category]! + value;
        } else {
          categorySums[category] = value;
        }
      }
    }

    mentalHealthDataList = categorySums.entries.map((entry) {
      return MentalHealthData(
        category: entry.key,
        value: entry.value,
      );
    }).toList();

    notifyListeners();
  }

  Future<void> getUserData() async {
    FirebaseFirestore.instance
        .collection('user')
        .where("uid", isEqualTo: uid)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        debugPrint("${event.size}");
        user.name = event.docs[0].data()['name'];
        user.center = event.docs[0].data()['center'];
        user.interest = event.docs[0].data()['interest'];
        mental = event.docs[0].data()['mental'];
      } else {
        // Handle case where no data is found
      }
    });

    notifyListeners();
  }

  void setSelectedOption(int page, int index, int value) {
    if (!selectedOptions.containsKey(page)) {
      selectedOptions[page] = [];
    }
    if (selectedOptions[page]!.length <= index) {
      selectedOptions[page]!.length = index + 1;
    }
    selectedOptions[page]![index] = value;
    notifyListeners();
  }

  List<int?> getSelectedOptions(int page) {
    return selectedOptions[page] ?? [];
  }

  Future<void> setData1(id, name, pwd, phone, enterDT, gender) async {
    user.id = id;
    user.name = name;
    user.pwd = pwd;
    user.phone = phone;
    user.birth = enterDT;
    user.gender = gender;
    notifyListeners();
  }

  Future<void> showUserData() async {
    debugPrint("id : ${user.id}");
    debugPrint("name : ${user.name}");
    debugPrint("phone : ${user.phone}");
    debugPrint("pwd : ${user.pwd}");
    debugPrint("enterDate : ${user.enterDate}");
    debugPrint("center : ${user.center}");
    debugPrint("birth : ${user.birth}");
    debugPrint("interest : ${user.interest}");
    debugPrint("severe : ${user.severe}");
    debugPrint("disable : ${user.disable}");
    debugPrint("gender : ${user.gender}");
    debugPrint("uid : $uid");
    notifyListeners();
  }

  Future<void> createUserData() async {
    FirebaseFirestore.instance.collection('user').add({
      "name": user.name,
      "id": user.id,
      "pwd": user.pwd,
      "phone": user.phone,
      "birth": user.birth,
      "gender": user.gender,
      "center": user.center,
      "enterDate": user.enterDate,
      "interest": user.interest,
      "disable": user.disable,
      "severe": user.severe,
      "uid": uid
    });
    notifyListeners();
  }

  Future<void> setData2(center, date) async {
    user.center = center;
    user.enterDate = date;
    notifyListeners();
  }

  Future<void> setData3(disable, severe) async {
    user.disable = disable;
    user.severe = severe;
    notifyListeners();
  }

  Future<void> addTotalScore(int num) async {
    totalScore += num;
    debugPrint("current total score : $totalScore");
    notifyListeners();
  }

  Future<void> setData4(interest) async {
    user.interest = interest;
    notifyListeners();
  }

  int calculateMentalScore() {
    double calculatedScore = ((133 - totalScore) / 133) * 100;
    return calculatedScore.round();
  }

  Future<void> saveMentalScore(int score) async {
    // Find the document where the uid field matches the current user's uid
    var querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: uid)
        .get();

    // Check if the query returned any documents
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document (assuming uid is unique, there should be only one)
      var userDocRef = querySnapshot.docs.first.reference;

      // Update the 'mental' field with the new score
      await userDocRef.update({
        'mental': totalScore,
      });
    } else {
      print('No document found for the current user UID');
    }
  }
}

class MentalHealthData {
  final String category;
  final int value;

  MentalHealthData({required this.category, required this.value});
}
