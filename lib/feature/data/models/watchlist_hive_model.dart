import 'package:hive/hive.dart';
part 'watchlist_hive_model.g.dart';


@HiveType(typeId: 1)
class WatchListHive {

  @HiveField(0)
  final String companyName;
  @HiveField(1)
  final String latestPrice;
  @HiveField(2)
  final String previousPrice;
  @HiveField(3)
  final int id;

  WatchListHive({
    required this.companyName,
    required this.latestPrice,
    required this.previousPrice,
    required this.id,
  });
}
