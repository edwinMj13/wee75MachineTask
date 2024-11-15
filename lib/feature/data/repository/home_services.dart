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
      //final response = await http.get(Uri.parse("$baseUrl$urlSearchFunctions$urlKeywords$tag$apiKey"));
      final response = await http.get(Uri.parse("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$tag&apikey=M91WRHVOU217QROZ"));
       // final response = await http.get(Uri.parse(
       //     "https://mocki.io/v1/69867981-9dca-4570-93d0-5efdf6f26898"));
      final json = jsonDecode(response.body);
      print("getSearchCompanyResults Response${json}]");
      if ((response.statusCode > 199 && response.statusCode < 300) && json["Information"]==null) {

        final data = SearchKeywordModel.fromJson(json);
        //print("Search Response - ${data.bestMatches}");

        data.bestMatches?.forEach((elem) {
          print("getSearchCompanyResults Names - $elem");
          compMethods
              .add(getCompanyStock(elem.name!, currentDate, previousDate));
        });
        final stockList = await Future.wait(compMethods);

        final successfull = stockList
            .map((q)=>q.fold((fnL)=>fnL, (fnR)=>fnR)).toList();


        print("getSearchCompanyResults successfull.runtimeType ${successfull.runtimeType}");
         print("getSearchCompanyResults successfull ${successfull}");

        //final lstList = stockList.map((comp){return TodayStockDetailsModel(companyName: comp["companyName"], latestPrice: comp["latestPrice"]);}).toList();
        if(successfull.runtimeType != String) {
          stockValueListener.value = List.from(successfull);
          dataList = "notnull";
        }else {
          dataList = successfull.first;
        }
      } else {
        dataList = json["Information"];
      }
    } catch (e) {
      print("Exception occurred on getSearchCompanyResults() ${e.toString()}");
    }
    return dataList;
  }

  Future<Either<String, WatchListHive>> getCompanyStock(
      String companyNames, String currentDate, String previousDate) async {
    print("current Date - $currentDate");
    print("previous Date - $previousDate");

    //final finalData = companyNames.map((name) async {
    print("Companies - ${companyNames}");
    try {
      // final response = await http.get(Uri.parse(
      //     "https://mocki.io/v1/b61517ee-9e0b-4aa0-a3d3-ea8aa33aef67"));
       final response = await http.get(Uri.parse("$baseUrl$urlGetCompanyFunctions$urlCompany$companyNames$urlOutputSize$apiKey"));
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print("getCompanyStock Response $json");
      if (response.statusCode > 199 && response.statusCode < 300) {
        final data = CompanyStockModel.fromJson(json);

        if (json["Information"]==null) {
          print("MOT INFORMATION");
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
        } else {
          print(" INFORMATION");
          return Left(json["Information"]);
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