import 'dart:convert';
SearchKeywordModel searchKeywordModelFromJson(String str) => SearchKeywordModel.fromJson(json.decode(str));
String searchKeywordModelToJson(SearchKeywordModel data) => json.encode(data.toJson());
class SearchKeywordModel {
  SearchKeywordModel({
      this.bestMatches,});

  SearchKeywordModel.fromJson(dynamic json) {
    if (json['bestMatches'] != null) {
      bestMatches = [];
      json['bestMatches'].forEach((v) {
        bestMatches?.add(BestMatches.fromJson(v));
      });
    }
  }
  List<BestMatches>? bestMatches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bestMatches != null) {
      map['bestMatches'] = bestMatches?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

BestMatches bestMatchesFromJson(String str) => BestMatches.fromJson(json.decode(str));
String bestMatchesToJson(BestMatches data) => json.encode(data.toJson());
class BestMatches {
  BestMatches({
      this.symbol, 
      this.name, 
      this.type, 
      this.region, 
      this.marketOpen, 
      this.marketClose, 
      this.timezone, 
      this.currency, 
      this.matchScore,});

  BestMatches.fromJson(dynamic json) {
    symbol = json['1. symbol'];
    name = json['2. name'];
    type = json['3. type'];
    region = json['4. region'];
    marketOpen = json['5. marketOpen'];
    marketClose = json['6. marketClose'];
    timezone = json['7. timezone'];
    currency = json['8. currency'];
    matchScore = json['9. matchScore'];
  }
  String? symbol;
  String? name;
  String? type;
  String? region;
  String? marketOpen;
  String? marketClose;
  String? timezone;
  String? currency;
  String? matchScore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['1. symbol'] = symbol;
    map['2. name'] = name;
    map['3. type'] = type;
    map['4. region'] = region;
    map['5. marketOpen'] = marketOpen;
    map['6. marketClose'] = marketClose;
    map['7. timezone'] = timezone;
    map['8. currency'] = currency;
    map['9. matchScore'] = matchScore;
    return map;
  }

}