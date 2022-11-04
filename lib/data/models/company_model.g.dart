// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = 2;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      phone: fields[2] as String?,
      logo: fields[3] as String?,
      logoResized: fields[4] as String?,
      loadingAppImage: fields[5] as String,
      appImageMorning: fields[6] as String,
      appImageDay: fields[7] as String,
      appImageEvening: fields[8] as String,
      about: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.logo)
      ..writeByte(4)
      ..write(obj.logoResized)
      ..writeByte(5)
      ..write(obj.loadingAppImage)
      ..writeByte(6)
      ..write(obj.appImageMorning)
      ..writeByte(7)
      ..write(obj.appImageDay)
      ..writeByte(8)
      ..write(obj.appImageEvening)
      ..writeByte(9)
      ..write(obj.about);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
