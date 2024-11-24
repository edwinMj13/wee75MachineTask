import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:week_three_machine_task_stock/feature/data/hardcoded_datas/hardcoded_default_data.dart';
import 'package:week_three_machine_task_stock/feature/domain/controllers/home_screen_controller.dart';

import '../../data/hardcoded_datas/constants.dart';
import '../../data/models/watchlist_hive_model.dart';
import '../../domain/controllers/common_cases.dart';

class DataTableWidget extends StatelessWidget {
  DataTableWidget({
    super.key,
    required this.companyDetails,
    required this.iconData,
    required this.tag,
    required this.callback,
    this.iconColor=Colors.white,
  });

  final HomeScreenController homeScreenController = HomeScreenController();
  final RxList<WatchListHive> companyDetails;
  final IconData iconData;
  final String tag;
  final Function(dynamic) callback;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns(),
      rows: rows(),
    );
  }

  List<DataRow> rows() {
    if (kDebugMode) {
      print("ROW $companyDetails");
    }
    return List.generate(companyDetails.length, (index) {
      return DataRow(
        cells: [
          DataCell(
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 70),
                child: Obx(
                  () => Text(
                    companyDetails[index].companyName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
          DataCell(
            Center(
              child: Obx(
                () => Text(
                  "$rupeeSymbol${CommonCases.toDouble(companyDetails[index].latestPrice).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 13,
                    color: getColor(companyDetails[index].latestPrice,companyDetails[index].previousPrice)
                  ),
                ),
              ),
            ),
          ),
          DataCell(
            Center(
              child: IconButton(
                onPressed: () {
                  if(tag=="home") {
                    callback(companyDetails[index]);
                  }else{
                    callback(companyDetails[index].id);
                  }
                },
                icon: Icon(iconData,color: iconColor,),
              ),
            ),
          ),
        ],
      );
    });
  }

  List<DataColumn> columns() {
    return List.generate(HardCodeDefaultData.watchListColumns.length, (index) {
      return DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: Text(HardCodeDefaultData.watchListColumns[index],
              style: textStyleFont(15)));
    });
  }

  TextStyle textStyleFont(double size) => TextStyle(fontSize: size);

   getColor(String latestPrice, String previousPrice) {
    return CommonCases.toDouble(latestPrice) >
        CommonCases.toDouble(previousPrice)
        ? Colors.green
        : Colors.red;
  }
}
