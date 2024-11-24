import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:week_three_machine_task_stock/feature/data/hardcoded_datas/constants.dart';
import 'package:week_three_machine_task_stock/feature/data/models/company_stock_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/error_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/search_keyword_model.dart';
import 'package:week_three_machine_task_stock/feature/data/models/todays_stock_details_model.dart';
import 'package:week_three_machine_task_stock/feature/domain/repositories/home_repository.dart';
import 'package:http/http.dart' as http;

import '../models/watchlist_hive_model.dart';

class HomeServices implements HomeRepo {
  @override
  Future<dynamic> getSearchCompanyResults(String tag) async {
    print("Search Tag - $tag");
    dynamic dataList;
    final date = DateTime.now();
    final currentDate = "${date.year}-${date.month}-${date.day - 1}";
    final previousDate = "${date.year}-${date.month}-${date.day - 2}";
    List<Future<Either<ErrorModel, WatchListHive>>> compMethods = [];
    try {
      final response = await http.get(Uri.parse("$baseUrl$urlSearchFunctions$urlKeywords$tag$apiKey"));
      //final response = await http.get(Uri.parse("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$tag$apiKey"));
      //final response = await http.get(Uri.parse("https://mocki.io/v1/0e716cbc-0930-422e-bb88-9da606d843ea"));  // Fake  "invalid Api"
      //final response = await http.get(Uri.parse("https://mocki.io/v1/87d507fc-70b8-4c4f-bf00-8dc60e7892fc")); // Fake bestMatches API
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (kDebugMode) {
        print("${response.statusCode} getSearchCompanyResults Response $json");
      }

      if ((response.statusCode > 199 && response.statusCode < 300)) {
        if (json.containsKey("bestMatches")) {
          final data = SearchKeywordModel.fromJson(json);
          debugPrint(
              "   debugPrint   -   Search Response - ${data.bestMatches}");

          data.bestMatches?.forEach((elem) {
            print(
                "getSearchCompanyResults  data.bestMatches NAMES - ${elem.name}");
            print(
                "getSearchCompanyResults  data.bestMatches Symbol - ${elem.symbol}");
            compMethods
                .add(getCompanyStock(elem.symbol!, currentDate, previousDate));
          });
          /*List<String> fakeApiList = [
            "https://mocki.io/v1/d2d6a05d-72f6-49f6-b6d2-c5b82817776b",
            "https://mocki.io/v1/43e0bd83-a6d6-4039-9b06-19ace7b394e4",
            "https://mocki.io/v1/d2d6a05d-72f6-49f6-b6d2-c5b82817776b",
            "https://mocki.io/v1/b61517ee-9e0b-4aa0-a3d3-ea8aa33aef67", // data
            "https://mocki.io/v1/b61517ee-9e0b-4aa0-a3d3-ea8aa33aef67",
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
              "getSearchCompanyResults successfull.runtimeType ${successfull[3]}");
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
            dataList = newList;
          } else {
            final error = successfull.first as ErrorModel;
            dataList = ErrorModel(
                code: "error", message: error.message);
          }
        } else if (json.containsKey("Information")) {
          dataList =
              ErrorModel(code: "Information", message: json["Information"]);
        } else if (json.containsKey("Error Message")) {
          dataList =
              ErrorModel(code: "Error Message", message: json["Error Message"]);
        } else {
          print("Unknown Error");
          dataList =
              ErrorModel(code: "Unknown Error", message: json.toString());
        }
      }
    } catch (e) {
      print("Exception occurred on getSearchCompanyResults() ${e.toString()}");
    }
    return dataList;
  }

  Future<Either<ErrorModel, WatchListHive>> getCompanyStock(
      String companyNames, String currentDate, String previousDate) async {
    print("current Date - $currentDate");
    print("previous Date - $previousDate");

    //final finalData = companyNames.map((name) async {
    print("Companies - $companyNames");
    try {
      //final response = await http.get(Uri.parse("https://mocki.io/v1/d2d6a05d-72f6-49f6-b6d2-c5b82817776b")); // Fake data
      //final response = await http.get(Uri.parse(elem)); // multiple Response Check
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
          return Left(ErrorModel(
            message: json["Error Message"],
            code: "Error Message",
          ));
        } else if (json.containsKey("Information")) {
          print(" INFORMATION  ERROR -  getCompanyStock");
          return Left(ErrorModel(code: "Information", message: json["Information"]));
        } else {
          print("Unknown Error");
          return Left(ErrorModel(
            message: "Unknown Error",
            code: json.toString(),
          ));
        }
        //print("companyStocks - ${companyStocks.companyName}");
      } else {
        return Left(ErrorModel(
          message: response.body,
          code: response.statusCode.toString(),
        ));
      }
    } catch (e) {
      print("Exception occurred on getCompanyStock() ${e.toString()}");

      return Left(ErrorModel(
        message: "Exception occurred on getCompanyStock()",
        code: e.toString(),
      ));
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
