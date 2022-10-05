import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/urls.dart';
import 'package:project_blueprint/core/domain/http_is_success.dart';
import 'package:project_blueprint/core/services/custom_client.dart';
import 'package:project_blueprint/data/models/cafe_model/cafe_model.dart';
import 'package:project_blueprint/domain/repositories/cafe_repository.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);
  final CustomClient client;
  List<CafeModel> listCafes = [];
  @override
  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getCafes(query));
      if (response.isSuccessful) {
        listCafes = [for (final item in jsonDecode(response.body)) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body, response: response, callFuncName: 'getCafeList');
      }
    }
    return listCafes;
  }
}
