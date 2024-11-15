import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/presentation/screen/home_screen.dart';
import 'package:week_three_machine_task_stock/feature/presentation/screen/watch_list_screen.dart';

class MainScreenCases {
  static ValueNotifier<int> mainScreenBottomNotifier = ValueNotifier(0);

  static changeCurrentBottomIndex(int index){
    print("changeCurrentBottomIndex $index");
    mainScreenBottomNotifier.value= index;
  }
  static Widget getMainScreenPages(){
    print("Selected Index ${mainScreenBottomNotifier.value}");
    switch(mainScreenBottomNotifier.value){
      case 0:
        return  HomeScreen();
      case 1:
        return const WatchListScreen();
      default:
        return const Text("No Screen");
    }
  }
}