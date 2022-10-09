import 'package:takk/data/models/token_model.dart';

abstract class AuthRepository {
  const AuthRepository();
  Future<TokenModel> updateToken();
  Future<TokenModel> setAuth(String phone, {String? code});
}
