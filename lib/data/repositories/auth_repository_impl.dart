import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  const AuthRepositoryImpl(this.client);
  final CustomClient client;
  @override
  Future<TokenModel> updateToken() async {
    final response = await client
        .post(Url.updateToken, body: {'refresh': client.tokenModel!.refresh});
    if (response.isSuccessful) {
      return TokenModel.fromJson(jsonDecode(response.body));
    }
    throw VMException(response.body.parseError(),
        response: response, callFuncName: 'updateToken');
  }

  @override
  Future<TokenModel> setAuth(String phone, {String? code}) async {
    final response = await client
        .post(Url.setAuth, body: {'phone': phone, 'sms_code': code ?? ''});
    if (response.isSuccessful) {
      return TokenModel.fromJson(jsonDecode(response.body));
    }
    throw VMException(response.body.parseError(),
        response: response, callFuncName: 'setAuth');
  }
}
