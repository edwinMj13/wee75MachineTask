import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week_three_machine_task_stock/feature/data/repository/home_services.dart';
import 'package:week_three_machine_task_stock/feature/presentation/widgets/data_table_widget.dart';
import 'package:week_three_machine_task_stock/feature/presentation/widgets/empty_list_widget.dart';

import '../../../domain/controllers/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeServices homeServices = HomeServices();

  final searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final HomeScreenController homeController = Get.put(HomeScreenController());

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    homeController.stockValueList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          searchField(),
          homeScreenContent(),
        ],
      ),
    );
  }

  Container searchField() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: searchController,
        autofocus: true,
        focusNode: focusNode,
        onChanged: (value) {
          homeController.getStockList(searchController.text);
        },
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(10.0),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget homeScreenContent() {
    return Expanded(
      child: Obx(() {
        if (homeController.stockValueList.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: double.infinity,
              child: DataTableWidget(
                companyDetails: homeController.stockValueList,
                iconData: Icons.add,
                tag: "home",
                callback: (details) =>
                    HomeScreenController.addData(details, context),
              ),
            ),
          );
        } else {
          return const EmptyListWidget(title: "Search for the company",icon: Icons.search,);
        }
      }
      ),
    );
  }
}
/*
if (homeController.stockValueList.isNotEmpty) {
              return DataTableWidget(
                companyDetails: homeController.stockValueList,
                iconData: Icons.add,
                tag: "home",
                callback: (details) =>
                    HomeScreenController.addData(details, context),
              );
            } else {
              return const Align(
                alignment: Alignment.center,
                child: EmptyListWidget(title: "Search for the company"),
              );
 */