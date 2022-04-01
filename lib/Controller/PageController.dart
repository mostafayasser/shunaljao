//بسم الله الرحمن الرحيم
import 'package:flutter/material.dart';

class MyPageController with ChangeNotifier {
  PageController controller = PageController(
    initialPage: 0,
  );
  int currentPage = 0;

  void incrementPage() {
    if (currentPage < 6) {
      controller.animateToPage(currentPage + 1,
          duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
      currentPage = currentPage + 1;
      notifyListeners();
    }
  }

  void decrementPage() {
    if (currentPage > 0) {
      controller.animateToPage(currentPage - 1,
          duration: Duration(milliseconds: 600), curve: Curves.easeInOut);
      currentPage = currentPage - 1;
      notifyListeners();
    }
  }

  void onPageChange(newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  bool menu = false;
  bool howTo = false;
  bool sevenDays = false;

/*  void changeMenu() {
    print('changeMenu++++++++++++++++++++');
    if (menu) {
      menu = false;
    } else {
      menu = true;
    }
    notifyListeners();
  }

  void changeHowTo() {
    print('changeHowTo++++++++++++++++++++++++++++++++++++$howTo');
    if (howTo) {
      howTo = false;
    } else {
      howTo = true;
    }
    notifyListeners();
  }

  void changeSevendaysTo() {
    print('changeSevendaysTo+++++++++++++++++++++++++++++');
    if (sevendays) {
      sevendays = false;
    } else {
      sevendays = true;
    }
    print("Home 7 days" + sevendays.toString());
    notifyListeners();
  }*/
}
