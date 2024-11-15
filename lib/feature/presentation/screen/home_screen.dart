import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/data/hardcoded_datas/constants.dart';
import 'package:week_three_machine_task_stock/feature/data/local_data/hive_operations.dart';
import 'package:week_three_machine_task_stock/feature/data/repository/home_services.dart';
import 'package:week_three_machine_task_stock/feature/domain/use_cases/home_screen_cases.dart';
import 'package:week_three_machine_task_stock/feature/presentation/widgets/empty_list_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeServices homeServices = HomeServices();

  final searchController = TextEditingController();
  HomeScreenCases homeScreenCases = HomeScreenCases();

  @override
  void initState() {
    // TODO: implement initState
    searchController.addListener(() {
      print("searchController ${searchController.text}");
      if (searchController.text.isNotEmpty) {
        print("object");
        homeScreenCases.getStockList(searchController.text,context);
      }else{
        HomeServices.stockValueListener.value = List.from([]);
        print("CLEAR");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    HomeServices.stockValueListener.value.clear();
    //HomeServices.stockValueListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: HomeServices.stockValueListener,
              builder: (context, snapShot, _) {
                if(snapShot.isNotEmpty) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          //color: Colors.white24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapShot[index].companyName,
                              overflow: TextOverflow.fade, maxLines: 1,),
                            Text(
                              "$rupeeSymbol ${snapShot[index].latestPrice}",
                              style: TextStyle(
                                  color: double.parse(
                                      snapShot[index].latestPrice) >
                                      double.parse(
                                          snapShot[index].previousPrice)
                                      ? Colors.green
                                      : Colors.red
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: IconButton(
                                onPressed: () {
                                  HiveOperations.addToStorage(snapShot[index]);
                                },
                                icon: Icon(Icons.add),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: snapShot.length,
                    separatorBuilder: (context, index) =>
                        Divider(
                          height: 0.5,
                          color: Colors.white10,
                        ),
                  );
                }else{
                  return EmptyListWidget();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
