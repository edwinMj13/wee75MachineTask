import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/hardcoded_datas/hardcoded_default_data.dart';
import '../../domain/controllers/main_screen_controller.dart';

class MainScreenBottomNavigationWidget extends StatelessWidget {
  MainScreenBottomNavigationWidget({
    super.key,
  });

  final mainController = Get.find<MainScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => BottomNavigationBar(
        items: List.generate(
          HardCodeDefaultData.getBottomNavigationData().length,
              (index) {
            return BottomNavigationBarItem(
              icon: HardCodeDefaultData.getBottomNavigationData()[index].icon,
              label: HardCodeDefaultData.getBottomNavigationData()[index].title,
            );
          },
        ),
        currentIndex: mainController.bottomIndex.value,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: mainController.changeCurrentBottomIndex,
      ),
    );
  }
}
