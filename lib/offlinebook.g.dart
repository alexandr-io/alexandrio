// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offlinebook.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineBookAdapter extends TypeAdapter<OfflineBook> {
  @override
  final int typeId = 12;

  @override
  OfflineBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineBook(
      title: fields[0] as String,
      id: fields[1] as String,
      libraryId: fields[2] as String,
      bytes: fields[3] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineBook obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.libraryId)
      ..writeByte(3)
      ..write(obj.bytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
