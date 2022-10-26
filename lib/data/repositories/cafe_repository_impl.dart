import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';

import '../../core/di/app_locator.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);

  final CustomClient client;

  List<CafeModel> _listCafes = [];
  List<CafeModel> _employeesCafeList = [];

  @override
  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getCafes(query));
      if (response.isSuccessful) {
        _listCafes = [for (final item in jsonDecode(response.body)['results']) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body.parseError(), response: response, callFuncName: 'getCafeList');
      }
    }
    return _listCafes;
  }

  @override
  Future<List<CafeModel>> getEmployeesCafeList({bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getEmployeeCafeList);
      if (response.isSuccessful) {
        _employeesCafeList = [for (final item in jsonDecode(response.body)['results']) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body.parseError(), response: response, callFuncName: 'getEmployeesCafeList');
      }
    }
    return _employeesCafeList;
  }

  @override
  Future<void> changeFavorite(CafeModel cafeModel) async {
    var response =
        await client.post(Url.changeFavorite(cafeModel.id!), body: {'is_favorite': '${!cafeModel.isFavorite!}'});
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(), response: response);
    }
  }

  @override
  Future<dynamic> getCafeProductList(String tag, int cafeId) async {
    var response = await client.get(Url.getCafeProducts(cafeId));
    if (response.isSuccessful) {
      var data = jsonDecode(response.body);

      return data;
    }
    throw VMException(response.body, response: response, callFuncName: 'getCafeProductList');
  }

  @override
  Future<void> getCartList() async {
    var response = await client.get(
      Url.getCartList,
    );
    if (response.isSuccessful) {
      var b = jsonDecode(response.body);
      if (b['items'].isEmpty) {
        locator<LocalViewModel>().cartList.clear();
        locator<LocalViewModel>().cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        locator<LocalViewModel>().cartResponse = CartResponse.fromJson(b);
        locator<LocalViewModel>().cartList.clear();
        for (var element in locator<LocalViewModel>().cartResponse.items) {
          locator<LocalViewModel>().cartList.add(element.id);
        }
      }
    }
  }

  @override
  List<CafeModel> get listCafes => _listCafes;

  @override
  List<CafeModel> get cafeTileList => locator<LocalViewModel>().isCashier ? _employeesCafeList : _listCafes;

  @override
  List<CafeModel> get employeesCafeList => _employeesCafeList;
}
