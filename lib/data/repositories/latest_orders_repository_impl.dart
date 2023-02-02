import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/constants.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/latest_orders_repository.dart';

import '../../config/constants/urls.dart';

class LatestOrdersRepositoryImpl extends LatestOrdersRepository {
  LatestOrdersRepositoryImpl(this.client);
  CustomClient client;

  List<CartResponse> _ordersList = [];

  @override
  Future<void> getUserOrders() async {
    var response = await client.get(Url.getUserOrders);
    if (response.isSuccessful) {
      _ordersList = [
        for (final item in jsonDecode(response.body)['results'])
          CartResponse.fromJson(item)
      ];
    } else {
      throw VMException(response.body.parseError(),
          callFuncName: 'getUserOrders', response: response);
    }
  }

  @override
  Future<void> setOrderLike(int id, bool like) async {
    var response = await client.patch(Url.getOrderInfo(id),
        body: jsonEncode({"like": like}), headers: headerContent);
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(),
          callFuncName: 'setOrderLike', response: response);
    }
  }

  @override
  List<CartResponse> get ordersList => _ordersList;
}
