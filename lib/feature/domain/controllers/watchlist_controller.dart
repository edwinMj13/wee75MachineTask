import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:week_three_machine_task_stock/feature/data/models/watchlist_hive_model.dart';

import '../../../core/utils/common_utils.dart';
import '../../data/local_data/hive_operations.dart';

class WatchListController extends GetxController{
  RxList<WatchListHive> watchListDataList = <WatchListHive>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   loadData();
  }

  loadData(){
    watchListDataList.value = HiveOperations.getDatas();
  }

  @override
  void refresh() {
    watchListDataList.clear();
    loadData();
  }

  deleteCompanyData(int index,BuildContext context){
    HiveOperations.deleteData(index);
    //HiveOperations.getDatas();
    watchListDataList.clear();
    watchListDataList.value = HiveOperations.getDatas();
    CommonUtils.showSnackBar(context, "Data is deleted");
  }
}