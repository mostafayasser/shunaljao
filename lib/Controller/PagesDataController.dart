//@dart=2.9
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnuljoe/Model/DayDataModel.dart';
import 'package:shnuljoe/Model/MealModel.dart';
import 'package:shnuljoe/Services/FirebaseAPI.dart';
import 'package:translator/translator.dart';

class PagesDataController with ChangeNotifier {
  List<String> temps = []; //done
  List<String> cities = []; //
  List<String> mealDescription = []; //done
  List<String> description = []; //done
  List<String> daysName = []; //done
  List<String> daysCode = []; //done
  List<String> month = []; //done
  List<String> dayDate = []; //done

  List<String> bgsCode = []; //done
  List<String> bgs = []; //done
  List<String> lunchBg = []; //done
  List<String> dinnerBg = []; //done
  List<String> allImages = []; //done
  // List<String> weatherAudio = [];
  List<MealModel> breakfasts = []; //done
  List<MealModel> lunches = []; //done
  List<MealModel> dinners = []; //done
  List<DayDataModel> pagesList = [];
//  List list1 = [];
  String userName;
  String userPic;

  int index = 0;

  Future<void> requestMeals(BuildContext context) async {
    print("request meal");
    List mealsList;
    bool friday = false;

    breakfasts.clear();
    dinners.clear();
    lunches.clear();

    for (var i = 0; i < 7; i++) {
      bool breakfast = true;
      bool dinner = true;
      bool lunch = true;
      // WeatherMealsList
      if (mealDescription[i] == "حار") {
        //hot
        print('############Hot Meal');
        mealsList =
            Provider.of<FirebaseRequests>(context, listen: false).allHotMeals;
      } else if (mealDescription[i] == 'معتدل') {
        //mild
        print('############Any Meal');
        mealsList =
            Provider.of<FirebaseRequests>(context, listen: false).allAnyMeals;
      } else {
        print('############Cold Meal');
        mealsList =
            Provider.of<FirebaseRequests>(context, listen: false).allColdMeals;
      }
      mealsList.shuffle();
      //  log("meallist ${mealsList.toList()}");
      log("=========================================");
      // FridayCheck
      if (daysCode[i] == "5") {
        friday = true;
      } else {
        friday = false;
      }

      for (var j = 0; j < mealsList.length; j++) {
        if (breakfast == true) {
          if (mealsList[j]['breakfast'] == breakfast) {
            breakfasts.add(MealModel(
              name: mealsList[j]['name'],
              number: mealsList[j]['number'],
              time: mealsList[j]['time'],
              imageURL: mealsList[j]['image'],
              steps: mealsList[j]['steps'],
              ingredient: mealsList[j]['ingredients'],
              videoURL: mealsList[j]['video'],
              type: "الفطور",
            ));
            breakfast = false;
            continue;
          }
        }

        if (mealsList[j]['friday'] == friday) {
          if (lunch == true) {
            if (mealsList[j]['lunch'] == lunch) {
              bool alreadyPresent = false;
              lunches.forEach((element) {
                if (element.name == mealsList[j]['name']) alreadyPresent = true;
              });
              if (!alreadyPresent) {
                //todo
                lunches.add(MealModel(
                  name: mealsList[j]['name'],
                  number: mealsList[j]['number'],
                  time: mealsList[j]['time'],
                  imageURL: mealsList[j]['image'],
                  steps: mealsList[j]['steps'],
                  ingredient: mealsList[j]['ingredients'],
                  videoURL: mealsList[j]['video'],
                  type: "الغداء",
                ));
                lunch = false;
                continue;
              }
            }
          }

          if (dinner == true) {
            if (mealsList[j]['dinner'] == dinner) {
              dinners.add(MealModel(
                name: mealsList[j]['name'],
                number: mealsList[j]['number'],
                time: mealsList[j]['time'],
                imageURL: mealsList[j]['image'],
                steps: mealsList[j]['steps'],
                ingredient: mealsList[j]['ingredients'],
                videoURL: mealsList[j]['video'],
                type: "العشاء",
              ));
              dinner = false;
              continue;
            }
          }
        }
      }
    }
  }

  Future<void> getUserData() async {
    var pref = await SharedPreferences.getInstance();
    final translator = GoogleTranslator();
    var uName = pref.getString("uName");
    if (uName.toString().contains("@")) {
      userName = uName;
    } else {
      var transl =
          await translator.translate(uName ?? " ", from: 'en', to: 'ar');
      print("getUserDaata" + "$transl");
      userName = transl.toString();
    }

    userPic = pref.getString("uPic");
    print("FKDFDFJ");
  }

  Future<void> createScreens() async {
    log("create screen start" + daysName.toString());

    if (pagesList.length == 0) {
      log("lunches ${lunches.length}");
      log("breakfast ${breakfasts.length}");
      log("dinners ${dinners.length}");
      log("bgs ${bgs.length}");
      /* log("breakfast" + breakfasts.toList().toString());
      log("dinners" + dinners.toList().toString());
      log("bgs" + bgs.toList().toString());
      log("temps" + temps.toList().toString());
      log('description' + description.toList().toString());
      log('daysName' + daysName.toList().toString());*/

      print("lunches: " + lunches.length.toString());
      print("breakfast: " + breakfasts.length.toString());
      print("dinners: " + dinners.length.toString());

      for (var i = 0; i < 7; i++) {
        pagesList.add(DayDataModel(
          lunch: lunches.length > i ? lunches[i] : null,
          breakfast: (breakfasts != null)
              ? (breakfasts.length > i ? breakfasts[i] : null)
              : null,
          dinner: dinners.length > i ? dinners[i] : null,
          bgURL: bgs.length > i ? bgs[i] : '',
          city: 'Bla Bla',
          temp: temps.length > i ? temps[i] : '',
          description: description.length > i ? description[i] : '',
          day: daysName.length > i ? daysName[i] : '',
          month: month.length > i ? month[i] : '',
          dayDate: dayDate.length > i ? dayDate[i] : '',
        ));
      }
    }

    log("create screen length" + pagesList[0].toString() + daysName.toString());
  }

  goToSettings(context) async {
    await Geolocator.openLocationSettings().then((value) {});

    //call function of whatever you need to do

    //await openAppSettings();
  }
}
