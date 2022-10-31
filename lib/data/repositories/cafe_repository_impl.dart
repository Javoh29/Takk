import 'dart:convert';

import 'package:http/http.dart';
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
import '../models/product_model.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);

  final CustomClient client;

  List<CafeModel> _listCafes = [];
  List<CafeModel> _employeesCafeList = [];
  List<ProductModel> _listProducts = [ProductModel()];

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
      } else {
        throw VMException(response.body.parseError(),
            response: response, callFuncName: 'getEmployeesCafeList');
      }
    }
    return _employeesCafeList;
  }

  @override
  Future<void> changeFavorite(CafeModel cafeModel) async {
    var response = await client.post(Url.changeFavorite(cafeModel.id!),
        body: {'is_favorite': '${!cafeModel.isFavorite!}'});
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
    throw VMException(response.body,
        response: response, callFuncName: 'getCafeProductList');
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

  @override
  Future<bool> checkTimestamp(String tag, int cafeId, int time) async {
    var response = await client.get(Url.checkTimestamp(cafeId, time));
    if (response.statusCode == 200) {
      bool isAvailable = jsonDecode(response.body)['available'];
      return isAvailable;
    } else {
      throw VMException(response.body.toString().parseError(),
          callFuncName: 'checkTimestamp');
    }
  }

  @override
  List<CafeModel> get listCafes => _listCafes;

  @override
  List<CafeModel> get cafeTileList =>
      locator<LocalViewModel>().isCashier ? _employeesCafeList : _listCafes;

  @override
  List<CafeModel> get employeesCafeList => _employeesCafeList;

  @override
  List<ProductModel> get listProducts => _listProducts;

  @override
  set listProducts(List<ProductModel> value) => _listProducts = value;

  @override
  Future<ProductModel?> getProductInfo(String tag, CartModel cartModel) async {
    var response = await client.get(Url.getProductInfo(cartModel.product));
    if (response.isSuccessful) {
      ProductModel m = ProductModel.fromJson(jsonDecode(response.body));
      m.comment = cartModel.instruction;
      for (var e in m.sizes) {
        if (e.id == cartModel.productSize) {
          e.mDefault = true;
        } else {
          e.mDefault = false;
        }
      }
      for (var e in m.modifiers) {
        for (var m in e.items) {
          bool isCheck = false;
          for (var p in cartModel.productModifiers) {
            if (p.id == m.id) isCheck = true;
          }
          m.mDefault = isCheck;
        }
      }
      m.count = cartModel.quantity;
      return m;
    } else {
      throw VMException(response.toString().parseError(),
          callFuncName: 'getProductInfo');
    }
  }

  @override
  Future<void> addItemCart({
    required String tag,
    required int cafeId,
    required ProductModel productModel,
    required int? cardItem,
  }) async {
    List<int> modList = [];
    int s = 0;
    for (var e in productModel.sizes) {
      if (e.mDefault) {
        s = e.id;
      }
    }
    for (var e in productModel.modifiers) {
      for (var element in e.items) {
        if (element.mDefault) {
          modList.add(element.id);
        }
      }
    }
    Response response;
    if (cardItem == null) {
      response = await client.post(
        Url.setItemCart,
        body: jsonEncode(
          {
            'cafe': cafeId,
            'instruction': productModel.comment,
            'quantity': productModel.count,
            'product': productModel.id,
            'product_size': s,
            'product_modifiers': modList
          },
        ),
      );
    } else {
      response = await client.put(
        Url.putCartItem(cardItem),
        body: jsonEncode(
          {
            'cafe': cafeId,
            'instruction': productModel.comment,
            'quantity': productModel.count,
            'product': productModel.id,
            'product_size': s,
            'product_modifiers': modList
          },
        ),
      );
    }
    if (response.isSuccessful) {
      if (cardItem == null) {
        locator<LocalViewModel>().cartList.add(productModel.id);
        // _cartResponse.subTotalPrice +=
        //     double.parse(jsonDecode(response.body)['sub_total_price']);
      } else {
        await getCartList();
      }
    } else {
      throw VMException(response.toString(), callFuncName: 'addItemCart');
    }
  }
}
