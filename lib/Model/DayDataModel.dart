//بسم الله الرحمن الرحيم
//@dart=2.9
import 'package:flutter/cupertino.dart';

import 'MealModel.dart';

class DayDataModel {
  DayDataModel(
      { //Info
      @required this.lunch,
      @required this.breakfast,
      @required this.dinner,
      @required this.bgURL,
      @required this.city,
      @required this.temp,
      @required this.description,
      @required this.day,
      @required this.month,
      @required this.dayDate});

  //Info
  MealModel lunch;
  MealModel breakfast;
  MealModel dinner;
  String bgURL = "";
  String city = "";
  String temp = "";
  String description = "";
  String day = "";
  String month = "";
  String dayDate = "";
}
