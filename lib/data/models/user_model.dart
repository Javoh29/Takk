import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  int? _id;
  @HiveField(1)
  String? _username;
  @HiveField(2)
  String? _dateOfBirthday;
  @HiveField(3)
  String? _phone;
  @HiveField(4)
  String? _avatar;
  @HiveField(5)
  String? _referralCode;
  @HiveField(6)
  String? _cashback;
  @HiveField(7)
  String? _balance;
  @HiveField(8)
  bool? _autoFill;
  @HiveField(9)
  String? _autoFillMinBalance;
  @HiveField(10)
  int? _userType;

  int? get id => _id;
  String? get username => _username;
  String? get dateOfBirthday => _dateOfBirthday;
  String? get phone => _phone;
  String? get avatar => _avatar;
  String? get referralCode => _referralCode;
  String? get cashback => _cashback;
  String? get balance => _balance;
  bool? get autoFill => _autoFill;
  String? get autoFillMinBalance => _autoFillMinBalance;
  int get userType => _userType ?? 3;

  UserModel(
      {int? id,
      String? username,
      String? dateOfBirthday,
      String? phone,
      String? avatar,
      String? referralCode,
      String? cashback,
      String? balance,
      bool? autoFill,
      int? userType,
      String? autoFillMinBalance}) {
    _id = id;
    _username = username;
    _dateOfBirthday = dateOfBirthday;
    _phone = phone;
    _avatar = avatar;
    _referralCode = referralCode;
    _cashback = cashback;
    _balance = balance;
    _autoFill = autoFill;
    _autoFillMinBalance = autoFillMinBalance;
    _userType = userType;
  }

  UserModel.fromJson(dynamic json) {
    _id = json["id"];
    _username = json["username"];
    _dateOfBirthday = json["date_of_birthday"];
    _phone = json["phone"];
    _avatar = json["avatar"];
    _referralCode = json["referral_code"];
    _cashback = json["cashback"];
    _balance = json["balance"];
    _autoFill = json["auto_fill"];
    _autoFillMinBalance = json["auto_fill_min_balance"];
    _userType = json["user_type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["username"] = _username;
    map["date_of_birthday"] = _dateOfBirthday;
    map["phone"] = _phone;
    map["avatar"] = _avatar;
    map["referral_code"] = _referralCode;
    map["cashback"] = _cashback;
    map["balance"] = _balance;
    map["auto_fill"] = _autoFill;
    map["auto_fill_min_balance"] = _autoFillMinBalance;
    map["user_type"] = _userType;
    return map;
  }
}
