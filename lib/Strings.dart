//بسم الله الرحمن الرحيم
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Constants.dart';

String welcomeTextAr = "وجبة ممتعة مناسبة للجو";
String signInAr = "التسجيل باستخدام فيسبوك";
String signInApple = "تسجيل الدخول مع أبل";
String slider1Header = "احصل على الجو";
String slider1Details = "توقعات حالة الجو لسبعة ايام";
String slider2Header = "شن حطيبي اليوم";
String slider2Details = "وجبات مناسبة للجو";
String slider3Header = "كيف انديرها";
String slider3Details = "المقادير وتعليمات الوصفة بالفيديو";
String next = "التالي";
String mainMeal = 'محشي';
String weatherNow = "الحار";
String tempText = "24";
String cityText = "درنة";
String cc = '° C';
String cc1 = '°';

class list {
  static List<String> userSearchItems = [];
}

//STYLES//
TextStyle welcomeTextStyle = TextStyle(
  color: primaryColorBlue,
  fontSize: 25.sp,
  fontWeight: FontWeight.bold,
);

TextStyle h1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 40.sp,
    color: primaryColorPink,
    fontFamily: 'DG-Bebo');
TextStyle h2 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24.sp,
    color: primaryColorPink,
    fontFamily: 'DG-Bebo');
TextStyle h3 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18.sp,
    fontFamily: 'DG-Bebo');
TextStyle h2W100 = TextStyle(
  // fontWeight: FontWeight.w100,
  color: Colors.white,
  fontSize: 24.sp,
  // color: primaryColorPink,
  /*fontFamily: 'DG-Bebo'*/
);
TextStyle h3W400 = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w100,
    fontSize: 20.sp,
    fontFamily: 'DG-Bebo');

TextStyle h2Arial = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.sp);
TextStyle h3Arial = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp);
TextStyle h4Arial = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp);
TextStyle h6Arial = TextStyle(
    color: Colors.white, fontWeight: FontWeight.w300, fontSize: 10.sp);
TextStyle h4ArialForTemp = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp);
TextStyle h5Arial = TextStyle(
    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22.sp);
TextStyle tempStyle1 = TextStyle(
  color: primaryColorPink,
  fontSize: 120.sp,
);
var tabColor = Color(0xFF979ACD);
var drawerTilesText = TextStyle(
  fontSize: 24.sp,
  color: Colors.white,
);
var drawerTilesTitle = TextStyle(
    fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.w700);
TextStyle tempStyle2 = TextStyle(
  color: Color(0xFF6C72B0),
  fontSize: 14.sp,
);
