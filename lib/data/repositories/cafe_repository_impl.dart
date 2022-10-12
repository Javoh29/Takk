import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';

import '../../core/di/app_locator.dart';
import '../models/cart_response_model.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);

  final CustomClient client;

  List<CafeModel> _listCafes = [];
  List<CafeModel> _employeesCafeList = [];
  CartResponse _cartResponse = CartResponse(
      id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  List<int> _cartList = [];

  @override
  Future<List<CafeModel>> getCafeList(
      {String? query, bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getCafes(query));
      if (response.isSuccessful) {
        _listCafes = [
          for (final item in jsonDecode(response.body)['results'])
            CafeModel.fromJson(item)
        ];
        locator<LocalViewModel>().listCafes = _listCafes;
      } else {
        throw VMException(response.body.parseError(),
            response: response, callFuncName: 'getCafeList');
      }
    }
    return _listCafes;
  }

  @override
  Future<List<CafeModel>> getEmployeesCafeList({bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getEmployeeCafeList);
      if (response.isSuccessful) {
        _employeesCafeList = [
          for (final item in jsonDecode(response.body)['results'])
            CafeModel.fromJson(item)
        ];
        locator<LocalViewModel>().employeesCafeList = _employeesCafeList;
      } else {
        throw VMException(response.body.parseError(),
            response: response, callFuncName: 'getEmployeesCafeList');
      }
    }
    return _employeesCafeList;
  }

  @override
  Future<void> getCartList() async {
    var response = await client.get(Url.getCartList);
    if (response.isSuccessful) {
      var body = jsonDecode(response.body);
      if (body['items'].isEmpty) {
        _cartList.clear();
        _cartResponse =
            CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        _cartResponse = CartResponse.fromJson(body);
        _cartList.clear();
        for (var element in _cartResponse.items) {
          _cartList.add(element.id);
        }
      }
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getCartList');
    }
  }

  @override
  Future<String?> changeFavorite(CafeModel cafeModel) async {
    var response = await client.post(Url.changeFavorite(cafeModel.id!),
        body: {'is_favorite': '${!cafeModel.isFavorite!}'});
    if (response.statusCode == 200) {
      return null;
    } else {
      return "Request Error";
    }
  }
}
