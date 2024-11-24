import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:week_three_machine_task_stock/feature/presentation/screen/home_screen/home_screen.dart';
import 'package:week_three_machine_task_stock/feature/presentation/screen/watchlist_screen/watch_list_screen.dart';

enum MConnectivityEnum {none,wifi,mobile}

class MainScreenController extends GetxController{
  //static ValueNotifier<int> mainScreenBottomNotifier = ValueNotifier(0);

  RxInt bottomIndex = 0.obs;

  final _connectivityType= MConnectivityEnum.none.obs;
  final Connectivity _connectivity =Connectivity();
  late StreamSubscription _streamSubscription;

  MConnectivityEnum get connectionType =>_connectivityType.value;

  set connectionType(value){
    _connectivityType.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    print("Main Controller");
    getConnectivityType();
    _streamSubscription = _connectivity.onConnectivityChanged.listen(_updateState);
  }

  Future<void> getConnectivityType() async {
    late ConnectivityResult connectivityResult;
    try{
      connectivityResult = await _connectivity.checkConnectivity();
    }on PlatformException catch (e){
      if(kDebugMode){
        print("getConnectivityType PlatformException $e");
      }
    }
    return _updateState(connectivityResult);
  }

  _updateState(ConnectivityResult connectivityResult) {
    switch(connectivityResult){
      case ConnectivityResult.wifi:
        connectionType = MConnectivityEnum.wifi;
        break;
      case ConnectivityResult.mobile:
        connectionType = MConnectivityEnum.mobile;
        break;
      case ConnectivityResult.none:
        connectionType = MConnectivityEnum.none;
        break;
      default :
        print("Failed to get connection type");
        break;
    }
  }


  @override
  void onClose() {
    _streamSubscription.cancel();
  }

  changeCurrentBottomIndex(int index){
    print("changeCurrentBottomIndex $index");
    bottomIndex.value= index;
  }
   Widget getMainScreenPages(int index){
    print("OnScreen Bottom Index $index");
    switch(index){
      case 0:
        return  HomeScreen();
      case 1:
        return  WatchListScreen();
      default:
        return const Text("No Screen");
    }
  }




}