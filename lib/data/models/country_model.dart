class CountryModel {
  late String _name;
  late String _flag;
  late String _code;
  late int _dialCode;
  late int _maxLength;

  String get name => _name;
  String get flag => _flag;
  String get code => _code;
  int get dialCode => _dialCode;
  int get maxLength => _maxLength;

  CountryModel(
      {required String name,
      required String flag,
      required String code,
      required int dialCode,
      required int maxLength}) {
    _name = name;
    _flag = flag;
    _code = code;
    _dialCode = dialCode;
    _maxLength = maxLength;
  }

  CountryModel.fromJson(dynamic json) {
    _name = json["name"];
    _flag = json["flag"];
    _code = json["code"];
    _dialCode = json["dial_code"];
    _maxLength = json["max_length"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["flag"] = _flag;
    map["code"] = _code;
    map["dial_code"] = _dialCode;
    map["max_length"] = _maxLength;
    return map;
  }
}
