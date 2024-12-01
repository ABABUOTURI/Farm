// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cl.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CropAdapter extends TypeAdapter<Crop> {
  @override
  final int typeId = 7;

  @override
  Crop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Crop(
      name: fields[0] as String,
      plantingDate: fields[1] as String,
      harvestingDate: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Crop obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.plantingDate)
      ..writeByte(2)
      ..write(obj.harvestingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LivestockAdapter extends TypeAdapter<Livestock> {
  @override
  final int typeId = 8;

  @override
  Livestock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Livestock(
      name: fields[0] as String,
      breed: fields[1] as String,
      feedingSchedule: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Livestock obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.breed)
      ..writeByte(2)
      ..write(obj.feedingSchedule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LivestockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
