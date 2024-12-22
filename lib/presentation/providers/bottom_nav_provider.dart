import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier{
  int currentIndex = 0;

  changeScreen(value){
    currentIndex = value;
    notifyListeners();
  }
  bool isBottomNavHide = false;
   changeBottomNavState(){
    isBottomNavHide =!isBottomNavHide;
    notifyListeners();
   }
}