import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'auth/user.dart';

class ApplicationState extends ChangeNotifier {
  UserData user =
      UserData("", "", "", "", "", "", DateTime.utc(1000), "", "", "", "");
  String uid = "";
  List<int> testDataList = [];

  ApplicationState() {
    debugPrint('initializing...');
    init();
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

  Future<void> getUserData() async {
    FirebaseFirestore.instance
        .collection('user')
        .where("uid", isEqualTo: uid)
        .snapshots()
        .listen((event) {
          if(event.docs.isNotEmpty){
            debugPrint("${event.size}");
            user.name = event.docs[0].data()['name'];
            user.center = event.docs[0].data()['center'];
            user.interest = event.docs[0].data()['interest'];
          }
          else{

          }

    });

    notifyListeners();
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

  Future<void> setData4(interest) async {
    user.interest = interest;
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
      "severe": user.disable,
      "uid": uid
    });
    notifyListeners();
  }

  Future<void> insertTestData(int idx, List<int?> testData)async{
    FirebaseFirestore.instance.collection('result').doc(uid).collection("page$idx").add({ "choice":testData});
    notifyListeners();
  }
}
