import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';

import '../../config/constants/urls.dart';

class CartRepositoryImpl extends CartRepository {
  CartRepositoryImpl(this.client);

  final CustomClient client;

  CartResponse _cartResponse = CartResponse(
      id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  List<int> _cartList = [];

  @override
  Future<void> addToCart(int id, bool isFav) async {
    var response =
        await client.get(isFav ? Url.addFavToCart(id) : Url.addOrderToCart(id));
    if (response.isSuccessful) {
      _cartResponse = CartResponse.fromJson(jsonDecode(response.body));
    } else {
      throw VMException(response.body.parseError(),
          callFuncName: 'addToCart', response: response);
    }
  }

  @override
  Future<void> setCartFov(String name, {int? favID}) async {
    var response = await client.post(Url.setCartFov,
        body: jsonEncode({
          "delivery": {
            "address": "Unknown",
            "latitude": 0.0,
            "longitude": 0.0,
            "instruction": ""
          },
          "name": name,
          if (favID != null) "favorite_cart": favID
        }));
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(),
          callFuncName: 'setCartFov', response: response);
    }
  }

  @override
  Future<void> clearCart() async {
    var response = await client.get(Url.clearCart);
    if (response.isSuccessful) {
      _cartResponse =
          CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      _cartList.clear();
      await locator<FavoriteRepository>().getFavList('FavoritesPage');
    } else {
      throw VMException(response.body,
          response: response, callFuncName: 'clearCart');
    }
  }

  @override
  Future<void> getCartList() async {
    var response = await client.get(Url.getCartList);
    if (response.isSuccessful) {
      var b = jsonDecode(response.body);
      if (b['items'].isEmpty) {
        _cartList.clear();
        _cartResponse =
            CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        _cartResponse = CartResponse.fromJson(b);
        _cartList.clear();
        for (var element in _cartResponse.items) {
          _cartList.add(element.id);
        }
      }
    }
  }

  @override
  CartResponse get cartResponse => _cartResponse;

  @override
  List<int> get cartList => _cartList;

}
import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cart_response.dart';

import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl extends CartRepository {
  late CustomClient client;
  List<int> _cartList = [];
  CartResponse _cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  

  @override
  Future<void> getCartList() async {
    var response = await client.get(Url.getCartList);
    if (response.isSuccessful) {
      var b = jsonDecode(response.body);
      if (b['items'].isEmpty) {
        _cartList.clear();
        _cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        _cartResponse = CartResponse.fromJson(b);
        _cartList.clear();
        for (var element in _cartResponse.items) {
          _cartList.add(element.id);
        }
      }
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'getCartList', response: response);
    }
  }

  @override
  Future<void> delCartItem(int id) async {
    var response = await client.delete(Url.deleteCartItem(id));
    if (response.statusCode == 204) {      
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'delCartItem', response: response);
    }
  }

  @override
  List<int> get cartList => _cartList;

  @override
  CartResponse get cartResponse => _cartResponse;

  

}
