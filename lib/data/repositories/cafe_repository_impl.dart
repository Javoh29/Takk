import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/constants.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/cart_repository.dart';

import '../../core/di/app_locator.dart';
import '../models/cart_response.dart';
import '../models/product_model.dart';

class CafeRepositoryImpl extends CafeRepository {
  CafeRepositoryImpl(this.client);

  final CustomClient client;

  List<CafeModel> _listCafes = [];
  CafeModel? _cafeModel;
  List<CafeModel> _employeesCafeList = [];
  int _totalCount = 0;
  List<ProductModel> _listProducts = [ProductModel()];

  @override
  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false}) async {
    await getTotalCount(query);
    if (isLoad) {
      final response = await client.get(Url.getCafes('$query&page_size=$_totalCount'));
      if (response.isSuccessful) {
        _listCafes = [for (final item in jsonDecode(response.body)['results']) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body.parseError(), response: response, callFuncName: 'getCafeList');
      }
    }
    return sortedList();
  }

  @override
  Future<void> getCafeInfo(int id) async {
    final response = await client.get(Url.getCafe(id));
    if (response.isSuccessful) {
      _cafeModel = CafeModel.fromJson(jsonDecode(response.body));
    } else {
      throw VMException(response.body.parseError(), response: response, callFuncName: 'getCafeList');
    }
  }

  Future<void> getTotalCount(String? query) async {
    final response = await client.get(Url.getCafes(query));
    if (response.isSuccessful) {
      _totalCount = jsonDecode(response.body)['count'];
    } else {
      throw VMException(response.body.parseError(), response: response, callFuncName: 'getTotalCount');
    }
  }

  @override
  Future<void> getEmployeesCafeList({bool isLoad = false}) async {
    if (isLoad) {
      final response = await client.get(Url.getEmployeeCafeList);
      if (response.isSuccessful) {
        _employeesCafeList = [for (final item in jsonDecode(response.body)['results']) CafeModel.fromJson(item)];
      } else {
        throw VMException(response.body.parseError(), response: response, callFuncName: 'getEmployeesCafeList');
      }
    }
  }

  @override
  Future<void> changeFavorite(CafeModel cafeModel) async {
    var response = await client.post(
      Url.changeFavorite(cafeModel.id!),
      body: jsonEncode(
        {"is_favorite": cafeModel.isFavorite!},
      ),
      headers: headerContent,
    );
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(), response: response);
    }
  }

  @override
  Future<dynamic> getCafeProductList(int cafeId) async {
    var response = await client.get(Url.getCafeProducts(cafeId));
    if (response.isSuccessful) {
      var data = jsonDecode(response.body);
      return data;
    }
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getCafeProductList');
  }

  @override
  Future<bool> checkTimestamp(int cafeId, int time) async {
    var response = await client.get(Url.checkTimestamp(cafeId, time));
    if (response.statusCode == 200) {
      bool isAvailable = jsonDecode(response.body)['available'];
      return isAvailable;
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'checkTimestamp', response: response);
    }
  }

  @override
  Future<ProductModel?> getProductInfo(CartModel cartModel) async {
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
      throw VMException(response.body.parseError(), callFuncName: 'getProductInfo', response: response);
    }
  }

  @override
  Future<void> addItemCart({
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
      response = await client.post(Url.setItemCart,
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
          headers: headerContent);
    } else {
      response = await client.put(Url.putCartItem(cardItem),
          body: jsonEncode(
            {
              'instruction': productModel.comment,
              'quantity': productModel.count,
              'product_size': s,
              'product_modifiers': modList
            },
          ),
          headers: headerContent);
    }
    if (response.isSuccessful) {
      if (cardItem == null) {
        locator<CartRepository>().cartList.add(productModel.id);
      } else {
        await locator<CartRepository>().getCartList();
      }
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'addItemCart', response: response);
    }
  }

  List<CafeModel> sortedList() {
    _listCafes.sort(
      (a, b) {
        if (b.isFavorite!) {
          return 1;
        }
        return -1;
      },
    );
    return _listCafes;
  }

  List<CafeModel> sortedEmplList() {
    _employeesCafeList.sort(
      (a, b) {
        if (b.isFavorite!) {
          return 1;
        }
        return -1;
      },
    );
    return _employeesCafeList;
  }

  @override
  List<CafeModel> get listCafes => sortedList();

  @override
  List<CafeModel> get cafeTileList => locator<LocalViewModel>().isCashier ? sortedEmplList() : sortedList();

  @override
  List<CafeModel> get employeesCafeList => sortedEmplList();

  @override
  List<ProductModel> get listProducts => _listProducts;

  @override
  set listProducts(List<ProductModel> value) => _listProducts = value;

  @override
  CafeModel get cafeModel => _cafeModel!;

  @override
  Future<void> changeStatusProduct(int id, int cafeId, bool isAvailable) async {
    final response = await client.post(Url.changeStatusProduct,
        body: jsonEncode({'is_available': isAvailable, 'product': id, 'cafe': cafeId}), headers: headerContent);
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(), response: response, callFuncName: 'changeStatusProduct');
    }
  }
}
