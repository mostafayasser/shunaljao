//بسم الله الرحمن الرحيم
import 'package:flutter/material.dart';

class LocalDataController with ChangeNotifier {
  bool languageBool = true;

  String sevenDays = "سبعة أيام كافية";

  String todayWeather = "اليوم";
  String tomorrowWeather = "بوكرا الجو";
  String monday = 'الاثنين';
  String tuesday = 'الثلاثاء';
  String wednesday = 'الاربعاء';
  String thursday = 'الخميس';
  String friday = 'الجمعة';
  String saturday = 'السبت';
  String sunday = 'الاحد';
  String weather = "الجو";

  String languageText = "اللغة";
  String rateUs = 'قيمنا';
  String share = 'مشاركة مع الأصدقاء';
  String listGrocer = 'قائمة بقالة';
  String logout = 'تسجيل الخروج';

  String lunchText = "غذاء";
  String breakfastText = "الفوطور";
  String dinnerText = "عشاء";

  String turningOff = "إيقاف";
  String turningOn = "تشغيل";

  void changeLanguage() {
    if (languageBool) {
      languageBool = false;
    } else {
      languageBool = true;
    }
    sevenDays = languageBool ? "سبعة أيام كافية" : "Seven Days's Enough";

    todayWeather = languageBool ? "اليوم الجو" : "Today Weather";
    tomorrowWeather = languageBool ? "بوكرا الجو" : "Tomorrow Weather";

    monday = languageBool ? 'الاثنين' : "Monday";
    tuesday = languageBool ? 'الثلاثاء' : "Tuesday";
    wednesday = languageBool ? 'الاربعاء' : "Wednesday";
    thursday = languageBool ? 'الخميس' : "Thursday";
    friday = languageBool ? 'الجمعة' : "Friday";
    saturday = languageBool ? 'السبت' : "Saturday";
    sunday = languageBool ? 'الاحد' : "Sunday";
    weather = languageBool ? "الجو" : "Weather";

    languageText = languageBool ? "اللغة" : "Language";
    rateUs = languageBool ? 'قيمنا' : "Rate us";
    logout = languageBool ? 'تسجيل الخروج' : "Logout";

    lunchText = languageBool ? "غذاء" : "Lunch";
    breakfastText = languageBool ? "الفوطور" : "Breakfast";
    dinnerText = languageBool ? "عشاء" : "Dinner";
    notifyListeners();
  }
}
