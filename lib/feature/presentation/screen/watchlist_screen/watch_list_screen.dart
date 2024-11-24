import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week_three_machine_task_stock/feature/domain/controllers/watchlist_controller.dart';
import 'package:week_three_machine_task_stock/feature/presentation/widgets/data_table_widget.dart';
import '../../widgets/empty_list_widget.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final WatchListController watchListController =
  Get.put(WatchListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<WatchListController>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        if (watchListController.watchListDataList.isNotEmpty) {
          return DataTableWidget(
            companyDetails: watchListController.watchListDataList,
            iconData: Icons.delete,
            tag: "watch",
            iconColor: Colors.redAccent,
            callback:(id) =>watchListController.deleteCompanyData(id,context));
        } else {
          return const EmptyListWidget(
            title: "There is nothing here",
            icon: CupertinoIcons.layers_alt,
          );
        }
      }),
    );
  }
}
