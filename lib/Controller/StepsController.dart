//بسم الله الرحمن الرحيم
//@dart=2.9
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shnuljoe/Model/MealModel.dart';

class StepsPageController with ChangeNotifier {
  PageController controller = PageController(
    initialPage: 0,
  );
  int currentPage = 0;

  int get getPage => currentPage;

  MealModel mealToCook;
  Map<int, bool> ingredientChecked = {};

  void setMeal(MealModel meal) {
    mealToCook = meal;
    for (int i = 0; i < mealToCook.ingredient.length; i++) {
      ingredientChecked[i] = false;
    }
    notifyListeners();
  }

  void toggleIngredientsChecked(index, value) {
    ingredientChecked[index] = value;
    notifyListeners();
  }

/*  void incrementPage() {
    if (currentPage < 6) {
      controller.animateToPage(currentPage + 1,
          duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      currentPage = currentPage + 1;
      notifyListeners();
    }
  }

  void decrementPage() {
    if (currentPage > 0) {
      controller.animateToPage(currentPage - 1,
          duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      currentPage = currentPage - 1;
      notifyListeners();
    }
  }*/

  void onPageChange(newPage) {
    currentPage = newPage;
    notifyListeners();
  }

/*
  bool menu = false;
  bool howTo = false;

  void changeMenu () {
    if(menu){
      menu = false;
    }else{
      menu = true;
    }
    notifyListeners();
  }
  void changeHowTo () {
    if(howTo){
      howTo = false;
    }else{
      howTo = true;
    }
    notifyListeners();
  }*/
  var text;

  assignText() {
    var list = [
      'الجايات أحسن من الرايحات',
      'العقل زينة',
      'الأفعال أبلغ من الأقوال',
      'أعطِ الخبز لخبازه ولو أكل نصه',
      'حمل الجماعة ريش.',
      'الصيت أطول من العمر',
      'كلمة امي كيف العسل في فمي.',
      'امش صحيح لا تعثر لا تطيح',
      'الي ما يأكل بيده ما يشبع.',
      'رزق الحلال يزيد وما ينقطع',
      'الصاحب على الصاحب يبيع عباته',
      'أرسل حكيما ولا توصيه',
      'دير الزيّنة وأنساها ... كان عشت على طول الزمان تلقاها',
      'الصهد للبراد والشكيره للطاسه',
      'اقتلني يا سمن البقر',
      'يغمس بحري الطبيخه',
      'اللي ما ياكل بيده ما يشبع'
    ];

    int random = new Random().nextInt(list.length);
    text = list.elementAt(random);
  }
}
