class UserModel {
  int? _id;
  String? _username;
  String? _dateOfBirthday;
  String? _phone;
  String? _avatar;
  String? _referralCode;
  String? _cashback;
  String? _balance;
  bool? _autoFill;
  String? _autoFillMinBalance;
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
