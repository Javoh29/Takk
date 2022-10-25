import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/latest_orders_repository.dart';

import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';

class LatestOrdersRepositoryImpl extends LatestOrdersRepository {
  LatestOrdersRepositoryImpl(this.client);

  CustomClient client;

  @override
  Future<void> getUserOrders() async {
    var response = await client.get(Url.getUserOrders);
    if (response.isSuccessful) {
      locator<LocalViewModel>().ordersList = [
        for (final item in jsonDecode(response.body)['results'])
          CartResponse.fromJson(item)
      ];
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'getUserOrders', response: response);
  }

  @override
  Future<void> setOrderLike(int id) async {
    var response = await client.patch(Url.getOrderInfo(id));
    if (response.isSuccessful) {}
    throw VMException(response.body.parseError(),
        callFuncName: 'getUserOrders', response: response);
  }

  @override
  Future<void> addToCart(int id, bool isFav) async {
    var response =
        await client.get(isFav ? Url.addFavToCart(id) : Url.addOrderToCart(id));
    if (response.isSuccessful) {
      locator<LocalViewModel>().cartResponse =
          CartResponse.fromJson(jsonDecode(response.body));
      // return 'Success';
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'addToCart', response: response);
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
    if (response.statusCode == 201) {}
    throw VMException(response.body.parseError(),
        callFuncName: 'setCartFov', response: response);
  }
}
