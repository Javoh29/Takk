// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel()
      .._id = fields[0] as int?
      .._username = fields[1] as String?
      .._dateOfBirthday = fields[2] as String?
      .._phone = fields[3] as String?
      .._avatar = fields[4] as String?
      .._referralCode = fields[5] as String?
      .._cashback = fields[6] as String?
      .._balance = fields[7] as String?
      .._autoFill = fields[8] as bool?
      .._autoFillMinBalance = fields[9] as String?
      .._userType = fields[10] as int?;
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._username)
      ..writeByte(2)
      ..write(obj._dateOfBirthday)
      ..writeByte(3)
      ..write(obj._phone)
      ..writeByte(4)
      ..write(obj._avatar)
      ..writeByte(5)
      ..write(obj._referralCode)
      ..writeByte(6)
      ..write(obj._cashback)
      ..writeByte(7)
      ..write(obj._balance)
      ..writeByte(8)
      ..write(obj._autoFill)
      ..writeByte(9)
      ..write(obj._autoFillMinBalance)
      ..writeByte(10)
      ..write(obj._userType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
