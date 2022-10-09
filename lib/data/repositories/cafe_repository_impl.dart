import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);
  final CustomClient client;
  List<CafeModel> listCafes = [];
  List<CafeModel> employessCafeList = [];
  @override
  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getCafes(query));
      if (response.isSuccessful) {
        listCafes = [for (final item in jsonDecode(response.body)['results']) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body.parseError(), response: response, callFuncName: 'getCafeList');
      }
    }
    return listCafes;
  }

  @override
  Future<List<CafeModel>> getEmployessCafeList({bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getEmployeeCafeList);
      if (response.isSuccessful) {
        employessCafeList = [for (final item in jsonDecode(response.body)['results']) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body.parseError(), response: response, callFuncName: 'getEmployessCafeList');
      }
    }
    return employessCafeList;
  }
}
