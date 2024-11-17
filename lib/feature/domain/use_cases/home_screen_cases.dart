import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/data/models/search_keyword_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/todays_stock_details_model.dart';
import 'package:week_three_machine_task_stock/feature/data/repository/home_services.dart';

import '../../../core/utils/debouncer_class.dart';

class HomeScreenCases {
  HomeServices homeServices = HomeServices();
  final debouncer = Debouncer(milliseconds: 1000);

  getStockList(String tag, BuildContext context) async {
    debouncer.run(() async {
      final data = await homeServices.getSearchCompanyResults(tag);
      if (data.runtimeType == String && data != "notnull") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data,
              style: const TextStyle(color: Colors.white),
            ),
            margin: const EdgeInsets.all(10.0),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      //print("Data ${data.runtimeType}");
    });
  }
}
