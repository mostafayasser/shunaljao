//@dart=2.9
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shnuljoe/Controller/PagesDataController.dart';

class FirebaseRequests with ChangeNotifier {
  List allAnyMeals = [];
  List allHotMeals = [];
  List allColdMeals = [];
  List bg1 = [];
  var random = new Random();
  int cold = 0;
  int hot = 0;
  int rain = 0;
  int sunny = 0;
  int thunder = 0;
  int snow = 0;

  Future<void> anyWeatherRequest() async {
    CollectionReference any = FirebaseFirestore.instance.collection('any');
    allAnyMeals.clear();
    await any.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        allAnyMeals.add(doc.data());
      });
    });
    notifyListeners();
  }

  Future<void> hotWeatherRequest() async {
    print("hotWeatherRequest");
    CollectionReference hot = FirebaseFirestore.instance.collection('hot');
    allHotMeals.clear();
    await hot.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        allHotMeals.add(doc.data());
      });
    });
    notifyListeners();
  }

  Future<void> coldWeatherRequest() async {
    print("coldWeatherRequest");
    CollectionReference cold = FirebaseFirestore.instance.collection('cold');
    allColdMeals.clear();
    await cold.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        allColdMeals.add(doc.data());
      });
    });
    notifyListeners();
  }

  Future<void> requestBG(BuildContext context) async {
    print("requestBG");
    List codes;
    List<String> bgs = [];
    List<String> lunchBg = [];
    List<String> dinnerBg = [];
    if (codes != null) codes.clear();
    codes = Provider.of<PagesDataController>(context, listen: false).bgsCode;

    print("codes: " + codes.toString());

    Provider.of<PagesDataController>(context, listen: false).bgs.clear();
    print("Umer " +
        Provider.of<PagesDataController>(context, listen: false)
            .bgs
            .length
            .toString());
    //if (Provider.of<PagesDataController>(context, listen: false).bgs.length !=
    //     7) {
    // var j = [1, 2, 3, 4, 5, 6];
    //j.shuffle();

    CollectionReference img = FirebaseFirestore.instance.collection('images');
    bg1.clear();
    await img.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        bg1.add(doc.data());
      });
    });

    Map counter = Map<String, int>();
    Map temp = Map<String, int>();
    temp = bg1[0];

    for (var key in temp.keys) {
      counter[key] = 0;
      temp[key].shuffle();
    }
    for (int i = 0; i < 7; i++) {
      print("DDDDD");
      String weather = codes[i].toString();
      bgs.add(temp[weather][counter[weather] % (temp[weather].length)]);
      counter[weather] = counter[weather] + 1;
      lunchBg.add(temp[weather][counter[weather] % (temp[weather].length)]);
      counter[weather] = counter[weather] + 1;
      dinnerBg.add(temp[weather][counter[weather] % (temp[weather].length)]);
      counter[weather] = counter[weather] + 1;
    }


    print('lunches: ' + lunchBg.toList().toString());
    print('dinner: ' + dinnerBg.toList().toString());
    print('backgrounds: ' + bgs.toList().toString());


    Provider.of<PagesDataController>(context, listen: false).bgs = bgs;
    Provider.of<PagesDataController>(context, listen: false).lunchBg = lunchBg;
    Provider.of<PagesDataController>(context, listen: false).dinnerBg =
        dinnerBg;
    //   }
  }

  counter(i) {
    switch (i) {
      case "cold":
        cold = cold + 1;
        break;
      case "hot":
        hot = hot + 1;
        break;
      case "rain":
        rain = rain + 1;
        break;
      case "sunny":
        sunny = sunny + 1;
        break;
      case "thunder":
        thunder = thunder + 1;
        break;
      case "snow":
        snow = snow + 1;
        break;
    }
  }

  int checkVal(i) {
    switch (i) {
      case "cold":
        return cold;
        break;
      case "hot":
        return hot;
        break;
      case "rain":
        return rain;
        break;
      case "sunny":
        return sunny;
        break;
      case "thunder":
        return thunder;
        break;
      case "snow":
        return snow;
        break;
    }
  }
}
