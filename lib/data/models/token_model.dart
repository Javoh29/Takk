import 'package:jbaza/jbaza.dart';

part 'token_model.g.dart';

@HiveType(typeId: 1)
class TokenModel {
  @HiveField(0)
  String? _refresh;
  @HiveField(1)
  String? _access;
  bool? _register;

  String? get refresh => _refresh;
  String? get access => _access;
  bool? get register => _register;

  set accessToken(String value) {
    _access = value;
  }

  TokenModel({String? refresh, String? access, bool? register}) {
    _refresh = refresh;
    _access = access;
    _register = register;
  }

  TokenModel.fromJson(dynamic json) {
    _refresh = json["refresh"];
    _access = json["access"];
    _register = json["register"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["refresh"] = _refresh;
    map["access"] = _access;
    map["register"] = _register;
    return map;
  }
}
