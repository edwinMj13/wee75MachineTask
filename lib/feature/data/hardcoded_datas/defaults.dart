import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/data/models/bottom_navigation_model.dart';

class HardCodeDefaultData {
  static List<BottomNavigationModel> getBottomNavigationData() {
    return [
      BottomNavigationModel(title: "Home", icon: const Icon(Icons.home)),
      BottomNavigationModel(title: "WatchList", icon: const Icon(Icons.list)),
    ];
  }

  static List<String> watchListColumns = [
    "Company",
    "Share Price",
    "Action",
  ];
}
