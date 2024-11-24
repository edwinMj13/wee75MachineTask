import 'dart:convert';
CompanyStockModel companyStockModelFromJson(String str) => CompanyStockModel.fromJson(json.decode(str));
String companyStockModelToJson(CompanyStockModel data) => json.encode(data.toJson());
class CompanyStockModel {
  CompanyStockModel({
      this.metaData, 
      this.timeSeriesDaily,});

  CompanyStockModel.fromJson(dynamic json) {
    metaData = json['Meta Data'] != null ? MetaData.fromJson(json['Meta Data']) : null;
    timeSeriesDaily = json['Time Series (Daily)'] != null ? TimeSeriesDaily.fromJson(json['Time Series (Daily)']) : null;
  }
  MetaData? metaData;
  TimeSeriesDaily? timeSeriesDaily;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (metaData != null) {
      map['Meta Data'] = metaData?.toJson();
    }
    if (timeSeriesDaily != null) {
      map['Time Series (Daily)'] = timeSeriesDaily?.toJson();
    }
    return map;
  }

}

TimeSeriesDaily timeSeriesdailyFromJson(String str) => TimeSeriesDaily.fromJson(json.decode(str));
String timeSeriesdailyFromJsonToJson(TimeSeriesDaily data) => json.encode(data.toJson());

class TimeSeriesDaily {
TimeSeriesDaily({
      this.today,});

TimeSeriesDaily.fromJson(dynamic json) {
    today = json['today'] != null ? Today.fromJson(json['today']) : null;
  }
  Today? today;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (today != null) {
      map['2024-11-13'] = today?.toJson();
    }
    return map;
  }

}

Today todayFromJson(String str) => Today.fromJson(json.decode(str));
String todayToJson(Today data) => json.encode(data.toJson());
class Today {
  Today({
      this.open, 
      this.high, 
      this.low, 
      this.close, 
      this.volume,});

  Today.fromJson(dynamic json) {
    open = json['1. open'];
    high = json['2. high'];
    low = json['3. low'];
    close = json['4. close'];
    volume = json['5. volume'];
  }
  String? open;
  String? high;
  String? low;
  String? close;
  String? volume;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['1. open'] = open;
    map['2. high'] = high;
    map['3. low'] = low;
    map['4. close'] = close;
    map['5. volume'] = volume;
    return map;
  }

}

MetaData metaDataFromJson(String str) => MetaData.fromJson(json.decode(str));
String metaDataToJson(MetaData data) => json.encode(data.toJson());
class MetaData {
  MetaData({
      this.Information, 
      this.Symbol, 
      this.LastRefreshed, 
      this.OutputSize, 
      this.TimeZone,});

  MetaData.fromJson(dynamic json) {
    Information = json['1. Information'];
    Symbol = json['2. Symbol'];
    LastRefreshed = json['3. Last Refreshed'];
    OutputSize = json['4. Output Size'];
    TimeZone = json['5. Time Zone'];
  }
  String? Information;
  String? Symbol;
  String? LastRefreshed;
  String? OutputSize;
  String? TimeZone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['1. Information'] = Information;
    map['2. Symbol'] = Symbol;
    map['3. Last Refreshed'] = LastRefreshed;
    map['4. Output Size'] = OutputSize;
    map['5. Time Zone'] = TimeZone;
    return map;
  }

}