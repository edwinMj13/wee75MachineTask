// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchListHiveAdapter extends TypeAdapter<WatchListHive> {
  @override
  final int typeId = 1;

  @override
  WatchListHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchListHive(
      companyName: fields[0] as String,
      latestPrice: fields[1] as String,
      previousPrice: fields[2] as String,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WatchListHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.latestPrice)
      ..writeByte(2)
      ..write(obj.previousPrice)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchListHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
