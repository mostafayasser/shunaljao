//بسم الله الرحمن الرحيم
import 'package:flutter/material.dart';

class SliderController with ChangeNotifier{
  PageController controller = PageController(
    initialPage: 0,
  );

  int currentPage = 0;

  void changePage(){
    if(currentPage<2){
      controller.animateToPage(currentPage+1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      currentPage = currentPage+1;
      notifyListeners();
    }
  }

  void onPageChange(newPage){
    currentPage = newPage;
    notifyListeners();
  }
}