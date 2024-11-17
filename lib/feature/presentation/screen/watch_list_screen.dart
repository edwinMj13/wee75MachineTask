import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/data/hardcoded_datas/defaults.dart';
import 'package:week_three_machine_task_stock/feature/data/local_data/hive_operations.dart';

import '../../data/models/watchlist_hive_model.dart';
import '../widgets/empty_list_widget.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    HiveOperations.getDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<WatchListHive>>(
        valueListenable: HiveOperations.watchListNotifier,
        builder: (context, snapData, _) {
          print("Watch List Data ${snapData.length}");
          if(snapData.isNotEmpty){
            return DataTable(
              columns: columns(),
              rows: rows(snapData),
            );
          }else{
            return EmptyListWidget(title: "There is nothing here",);
          }
        });
  }

  List<DataRow> rows(List<WatchListHive> snapData) {
    return List.generate(snapData.length, (index) {
              return DataRow(
                cells: [
                  DataCell(Center(child: Text(snapData[index].companyName,style: textStyleFont(12),))),
                  DataCell(Center(child: Text(snapData[index].latestPrice,style: textStyleFont(12)))),
                  DataCell(IconButton(
                    onPressed: () =>
                        HiveOperations.deleteData(snapData[index].id),
                    icon: const Icon(Icons.delete,color: Colors.redAccent,),
                  )),
                ],
              );
            });
  }

  TextStyle textStyleFont(double size) => TextStyle(fontSize: size);

  List<DataColumn> columns() {
    return List.generate(HardCodeDefaultData.watchListColumns.length,
                    (index) {
                  return DataColumn(
                      headingRowAlignment: MainAxisAlignment.center,
                      label: Text(HardCodeDefaultData.watchListColumns[index],style: textStyleFont(15)));
                });
  }
}
