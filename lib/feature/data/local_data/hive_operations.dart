import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:week_three_machine_task_stock/feature/data/models/todays_stock_details_model.dart';

import '../models/watchlist_hive_model.dart';

class HiveOperations {
  static ValueNotifier<List<WatchListHive>> watchListNotifier = ValueNotifier([]);
  static addToStorage(WatchListHive dataModel) async {
    try{
      //final dbData = await Hive.openBox<WatchListHive>("comp");
      final dbData = Hive.box<WatchListHive>("comp");
      print("addToStorage Data ${dbData.values}");
      final id = await dbData.add(dataModel);
      // final entry = dbData.get(id);
      // final lastModel = TodayStockDetailsModel(
      //   companyName: dataModel.companyName,
      //   latestPrice: dataModel.latestPrice,
      //   previousPrice: dataModel.previousPrice,
      //   id: id,
      // );
      // if (entry != null) {
      //   await dbData.put(id, lastModel);
      // }
      print("dbData - $dbData");
    }catch (e){
      print("Add Data Exception ${e.toString()}");
    }

  }

  static getDatas(){
    final dbData = Hive.box<WatchListHive>("comp");
    watchListNotifier.value.clear();
    //watchListNotifier.value.addAll(dbData.values);

    watchListNotifier.value = List.from(dbData.values);
    print("Get Data ${watchListNotifier.value}");
  }

  static deleteData(int id){
    print("ID Delete $id");
    final dbData = Hive.box<WatchListHive>("comp");
    dbData.deleteAt(id);
    getDatas();
  }

}
