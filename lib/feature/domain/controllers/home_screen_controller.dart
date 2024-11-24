import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week_three_machine_task_stock/feature/data/models/error_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/watchlist_hive_model.dart';
import 'package:week_three_machine_task_stock/feature/data/repository/home_services.dart';

import '../../../core/utils/common_utils.dart';
import '../../../core/utils/debouncer_class.dart';
import '../../data/local_data/hive_operations.dart';

class HomeScreenController extends GetxController {
  HomeServices homeServices = HomeServices();
  final debouncer = Debouncer(milliseconds: 1000);
  RxList<WatchListHive> stockValueList = <WatchListHive>[].obs;

  Rx<ErrorModel> errorData = ErrorModel().obs;

  getStockList(String tag) async {
    debouncer.run(() async {
      if (tag.isNotEmpty) {
        final data = await homeServices.getSearchCompanyResults(tag);
        print(data.runtimeType);
        if (data is ErrorModel) {
          errorData.value = data;
          stockValueList.value = List.from([]);
          Get.snackbar(
            "Error",
            data.message!,
            snackStyle: SnackStyle.FLOATING,
            backgroundColor: Colors.redAccent,
            margin: const EdgeInsets.all(10.0),
          );
        } else if (data is List<WatchListHive>) {
          stockValueList.value = List.from(data);
          print("Inside this ${stockValueList}");
        }
      } else {
        print("CLEAR INSIDE");
        if (stockValueList.isNotEmpty) {
          stockValueList.clear();
          print("CLEAR CLEARED");
        }
      }
    });
  }

  static addData(dynamic details,BuildContext context){
    HiveOperations.addToStorage(details as WatchListHive);
    CommonUtils.showSnackBar(context, "Data is added");
  }
}
