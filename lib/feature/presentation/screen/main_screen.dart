import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:week_three_machine_task_stock/feature/data/models/bottom_navigation_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/watchlist_hive_model.dart';
import 'package:week_three_machine_task_stock/feature/domain/use_cases/main_screen_cases.dart';

import '../../data/hardcoded_datas/defaults.dart';
import '../../data/models/todays_stock_details_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    openBox();
    super.initState();
  }
   openBox() async {
    await Hive.openBox<WatchListHive>("comp");
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: MainScreenCases.mainScreenBottomNotifier,
        builder: (context,snapData,_) {
          return Scaffold(
          appBar: AppBar(
            title: Text(snapData==0?"Stock Data":"WatchList"),
          ),
          bottomNavigationBar:  MainScreenBottomNavigationWidget(snapData: snapData,),
          body: MainScreenCases.getMainScreenPages(),
        );
      }
    );
  }


}

class MainScreenBottomNavigationWidget extends StatelessWidget {
   const MainScreenBottomNavigationWidget({
    super.key,
    required this.snapData
  });
   final int snapData;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
          items: List.generate(
              HardCodeDefaultData.getBottomNavigationData().length, (index) {
            return BottomNavigationBarItem(
              icon: HardCodeDefaultData.getBottomNavigationData()[index].icon,
              label: HardCodeDefaultData.getBottomNavigationData()[index].title,
            );
          },),
          currentIndex: snapData,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: MainScreenCases.changeCurrentBottomIndex,
        );
  }
}
