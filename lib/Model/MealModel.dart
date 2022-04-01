//بسم الله الرحمن الرحيم
//@dart=2.9
import 'package:flutter/material.dart';

class MealModel {
  MealModel({
    //Info
    @required this.name,
    @required this.type,
    @required this.number,
    @required this.time,
    @required this.imageURL,
    //HowToData
    @required this.steps,
    @required this.ingredient,
    @required this.videoURL,

    //  @required this.bgUrl,
  });

  //Info
  String name = 'd';
  String type = 'f';
  var number;
  var time;
  String imageURL = 'sd';
  //HowToData
  List steps = [];
  List ingredient = [];
  String videoURL = 's';

  // String bgUrl= 's';
}
