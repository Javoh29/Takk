import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/urls.dart';
import 'package:project_blueprint/core/domain/http_is_success.dart';
import 'package:project_blueprint/data/models/comp_model.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<CompanyModel> getCompanyModel() async {
    var response = await get(Url.getCompInfo);
    if (response.isSuccessful) return CompanyModel.fromJson(jsonDecode(response.body));
    throw VMException(response.body, callFuncName: 'getCompanyModel', response: response);
  }
}
