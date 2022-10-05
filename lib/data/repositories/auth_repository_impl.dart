import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/urls.dart';
import 'package:project_blueprint/core/domain/http_is_success.dart';
import 'package:project_blueprint/core/services/custom_client.dart';
import 'package:project_blueprint/data/models/token_model.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  const AuthRepositoryImpl(this.client);
  final CustomClient client;
  @override
  Future<TokenModel> updateToken() async {
    final response = await client.post(Url.updateToken, body: {'refresh': client.tokenModel!.refresh});
    if (response.isSuccessful) {
      return TokenModel.fromJson(jsonDecode(response.body));
    }
    throw VMException(response.body, response: response, callFuncName: 'updateToken');
  }
}
