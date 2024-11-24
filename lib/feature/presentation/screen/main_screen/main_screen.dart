import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:week_three_machine_task_stock/feature/data/models/watchlist_hive_model.dart';

import '../../../domain/controllers/main_screen_controller.dart';
import '../../widgets/bottom_navigation_widget.dart';
import '../../widgets/internet_not_available_widget.dart';

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
    final MainScreenController mainScreenCases = Get.put(MainScreenController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(mainScreenCases.bottomIndex.value == 0
            ? "Stock Data"
            : "WatchList")),
      ),
      bottomNavigationBar: MainScreenBottomNavigationWidget(),
      body: Obx(
        () {
          if (kDebugMode) {
            print("Updating Network Status ${mainScreenCases.connectionType}");
          }

          return mainScreenCases.connectionType == MConnectivityEnum.none
              ? const InternetNotAvailableWidget()
              : mainScreenCases.getMainScreenPages(mainScreenCases.bottomIndex.value);
        },
      ),
    );
  }
}


