class TodayStockDetailsModel{
  final String companyName;
  final String latestPrice;
  final String previousPrice;
  final int id;

  TodayStockDetailsModel({required this.companyName, required this.latestPrice,required this.previousPrice,required this.id, });

  TodayStockDetailsModel fromMap(map){
    return TodayStockDetailsModel(companyName: map["companyName"], latestPrice: map["latestPrice"],previousPrice: map["previousPrice"],id: map["id"],);
  }

}