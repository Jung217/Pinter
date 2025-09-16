// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ritual.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RitualAdapter extends TypeAdapter<Ritual> {
  @override
  final int typeId = 0;

  @override
  Ritual read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ritual()
      ..complete = fields[0] as double
      ..checkedOn = fields[9] as DateTime?
      ..url = fields[1] as String
      ..background = fields[2] as String?
      ..time = (fields[3] as Map).cast<dynamic, dynamic>()
      ..type = fields[4] as String?
      ..expiry = fields[5] as DateTime?
      ..position = fields[6] as int?
      ..priority = fields[7] as int
      ..createdOn = fields[8] as DateTime?
      ..duration = fields[10] as double?
      ..initValue = fields[11] as int?
      ..stackTime = fields[12] as bool
      ..integralStackValue = fields[13] as bool;
  }

  @override
  void write(BinaryWriter writer, Ritual obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.complete)
      ..writeByte(9)
      ..write(obj.checkedOn)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.background)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.expiry)
      ..writeByte(6)
      ..write(obj.position)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.createdOn)
      ..writeByte(10)
      ..write(obj.duration)
      ..writeByte(11)
      ..write(obj.initValue)
      ..writeByte(12)
      ..write(obj.stackTime)
      ..writeByte(13)
      ..write(obj.integralStackValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RitualAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
