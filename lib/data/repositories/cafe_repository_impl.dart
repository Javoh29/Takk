import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';

import '../../core/di/app_locator.dart';
import '../models/cart_response.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);
  final CustomClient client;
  List<CafeModel> listCafes = [];
  List<CafeModel> employessCafeList = [];

  @override
  Future<List<CafeModel>> getCafeList(
      {String? query, bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getCafes(query));
      if (response.isSuccessful) {
        listCafes = [
          for (final item in jsonDecode(response.body)['results'])
            CafeModel.fromJson(item)
        ];
      } else {
        throw VMException(response.body.parseError(),
            response: response, callFuncName: 'getCafeList');
      }
    }
    locator<LocalViewModel>().listCafes = listCafes;
    return listCafes;
  }

  @override
  Future<List<CafeModel>> getEmployessCafeList({bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getEmployeeCafeList);
      if (response.isSuccessful) {
        employessCafeList = [
          for (final item in jsonDecode(response.body)['results'])
            CafeModel.fromJson(item)
        ];
      } else {
        throw VMException(response.body.parseError(),
            response: response, callFuncName: 'getEmployessCafeList');
      }
    }
    return employessCafeList;
  }

  @override
  Future<dynamic> getCafeProductList(String tag, int cafeId) async {
    var response = await client.get(Url.getCafeProducts(cafeId));
    if (response.isSuccessful) {
      var data = jsonDecode(response.body);

      return data;
    }
    throw VMException(response.body,
        response: response, callFuncName: 'getCafeProductList');
  }

  @override
  Future<void> getCartList(String tag) async {
    var response = await client.get(Url.getCartList,);
    if (response.isSuccessful) {
      var b = jsonDecode(response.body);
      if (b['items'].isEmpty) {
        locator<LocalViewModel>().cartList.clear();
        locator<LocalViewModel>().cartResponse =
            CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        locator<LocalViewModel>().cartResponse = CartResponse.fromJson(b);
        locator<LocalViewModel>().cartList.clear();
        for (var element in locator<LocalViewModel>().cartResponse.items) {
          locator<LocalViewModel>().cartList.add(element.id);
        }
      }
    }
  }
}
