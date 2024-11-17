import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/data/hardcoded_datas/constants.dart';
import 'package:week_three_machine_task_stock/feature/data/models/CompanyStockModel.dart';
import 'package:week_three_machine_task_stock/feature/data/models/search_keyword_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/todays_stock_details_model.dart';
import 'package:week_three_machine_task_stock/feature/domain/repositories/home_repository.dart';
import 'package:http/http.dart' as http;

import '../models/watchlist_hive_model.dart';

class HomeServices implements HomeRepo {
  static ValueNotifier<List<WatchListHive>> stockValueListener =
      ValueNotifier([]);

  @override
  Future<String> getSearchCompanyResults(String tag) async {
    print("Search Tag - $tag");
    dynamic dataList;
    final date = DateTime.now();
    final currentDate = "${date.year}-${date.month}-${date.day - 1}";
    final previousDate = "${date.year}-${date.month}-${date.day - 2}";
    List<Future<Either<String, WatchListHive>>> compMethods = [];
    try {
      final response = await http.get(Uri.parse("$baseUrl$urlSearchFunctions$urlKeywords$tag$apiKey"));
      //final response = await http.get(Uri.parse("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$tag$apiKey"));
      //final response = await http.get(Uri.parse("https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea"));  // Fake  "invalid Api"
      //final response = await http.get(Uri.parse("https://mocki.io/v1/69867981-9dca-4570-93d0-5efdf6f26898"));  // Fake bestMatches API
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print("${response.statusCode} getSearchCompanyResults Response${json}]");
      if ((response.statusCode > 199 && response.statusCode < 300)) {
        if (json.containsKey("bestMatches")) {
          final data = SearchKeywordModel.fromJson(json);
          //print("Search Response - ${data.bestMatches}");

          data.bestMatches?.forEach((elem) {
            print("getSearchCompanyResults Names - $elem");
            compMethods.add(getCompanyStock(elem.name!, currentDate, previousDate));
          });
          /*List<String> fakeApiList = [
            "https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea",
            "https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea",
            "https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea",
            "https://mocki.io/v1/b61517ee-9e0b-4aa0-a3d3-ea8aa33aef67", // data
            "https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea",
          ];
          for (var elem in fakeApiList) {
            print("getSearchCompanyResults Names - $elem");
            compMethods
                .add(getCompanyStock(elem, currentDate, previousDate, elem));
          }*/
          final stockList = await Future.wait(compMethods);

          final successfull =
              stockList.map((q) => q.fold((fnL) => fnL, (fnR) => fnR)).toList();

          print(
              "getSearchCompanyResults successfull.runtimeType ${successfull[3].runtimeType}");
          print("getSearchCompanyResults successfull $successfull");

          //final lstList = stockList.map((comp){return TodayStockDetailsModel(companyName: comp["companyName"], latestPrice: comp["latestPrice"]);}).toList();
          List<WatchListHive> newList = [];
          for (int i = 0; i < successfull.length; i++) {
            print("Inside Loop");
            if (successfull[i].runtimeType == WatchListHive) {
              print("Inside Loop Condition");
              newList.add(successfull[i] as WatchListHive);
            }
          }
          print("newList $newList");
          if (newList.isNotEmpty) {
            stockValueListener.value = List.from(newList);
            print("stockValueListener.value  -  ${stockValueListener.value}");
            // if there is WatchListHive at least 1 then show it. if there is no WatchList return the error;
            dataList = "notnull";
          } else {
            if(stockValueListener.value.isNotEmpty){
              stockValueListener.value=List.from([]);
            }
            dataList = successfull.first;
          }
        } else if (json.containsKey("Information")) {
          dataList = json["Information"];
        } else if (json.containsKey("Error Message")) {
          dataList = json["Error Message"];
        } else {
          print("Unknown Error");
          dataList = json.toString();
        }
      }
    } catch (e) {
      print("Exception occurred on getSearchCompanyResults() ${e.toString()}");
    }
    return dataList;
  }

  Future<Either<String, WatchListHive>> getCompanyStock(String companyNames,
      String currentDate, String previousDate) async {
    print("current Date - $currentDate");
    print("previous Date - $previousDate");

    //final finalData = companyNames.map((name) async {
    print("Companies - $companyNames");
    try {
      //final response = await http.get(Uri.parse("https://mocki.io/v1/b61517ee-9e0b-4aa0-a3d3-ea8aa33aef67"));  // Fake data
      //final response = await http.get(Uri.parse(mockApi)); // multiple Response Check
      //final response = await http.get(Uri.parse("https://mocki.io/v1/16f57d52-ad4d-44d0-93dd-bcd8dd481571"));  // Fake Information
      //final response = await http.get(Uri.parse("https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea"));  // Fake "invalid Api"
      final response = await http.get(Uri.parse("$baseUrl$urlGetCompanyFunctions$urlCompany$companyNames$urlOutputSize$apiKey"));
      //final response = await http.get(Uri.parse("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$companyNames&outputsize=compact$apiKey"));
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print("${response.statusCode}getCompanyStock Response $json");
      if (response.statusCode > 199 && response.statusCode < 300) {
        final data = CompanyStockModel.fromJson(json);

        if (json.containsKey("Time Series (Daily)")) {
          print("NOT INFORMATION");
          Map<String, dynamic> today = json["Time Series (Daily)"];

          final listData = today.entries.take(2).toList();
          List<String> listAmounts = [];
          for (var data in listData) {
            listAmounts.add(data.value["4. close"]);
          }
          print("Time\n"
              "${listAmounts[0]}\n"
              "${listAmounts[1]}");
          // print(
          //     "CompanyStockModel Response currentDate - ${json["Time Series (Daily)"][listAmounts[0]]}");
          // print(
          //     "CompanyStockModel Response previousDate - ${json["Time Series (Daily)"][listAmounts[1]]}");
          return Right(WatchListHive(
            companyName: data.metaData!.Symbol!,
            latestPrice: listAmounts[0],
            previousPrice: listAmounts[1],
            id: 0,
          ));
        } else if (json.containsKey("Error Message")) {
          print(" Error Message   -   getCompanyStock");
          return Left(json["Error Message"]);
        } else if (json.containsKey("Information")) {
          print(" INFORMATION  ERROR -  getCompanyStock");
          return Left(json["Information"]);
        } else {
          print("Unknown Error");
          return Left(json.toString());
        }
        //print("companyStocks - ${companyStocks.companyName}");
      } else {
        return Left(response.body);
      }
    } catch (e) {
      print("Exception occurred on getCompanyStock() ${e.toString()}");

      return Left("Exception occurred ${e.toString()}");
    }
    //}).toList();

    // return finalData;
  }
}
/*
Sometimes response after Future.wait is
[
Instance of 'WatchListHive',
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.,
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.,
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.,
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.,
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.,
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.,
Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for TIME_SERIES_DAILY.
];
 */