//بسم الله الرحمن الرحيم
//@dart=2.9
import 'package:flutter/material.dart';

class BgModel {
  BgModel({
    @required this.cloudy,
    @required this.hot,
    @required this.rain,
    @required this.snow,
    @required this.sunny,
    @required this.thunder,
  });

  //Info
  List cloudy = [];
  List hot = [];
  List rain = [];
  List snow = [];
  List sunny = [];
  List thunder = [];
}
