import 'package:flutter/material.dart';

abstract class HomeRepo{
   Future<dynamic> getSearchCompanyResults(String tag );
}