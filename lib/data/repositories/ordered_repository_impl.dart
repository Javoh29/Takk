import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/domain/repositories/ordered_repository.dart';

import '../models/cart_response.dart';

class OrderedRepositoryImpl extends OrderedRepository {
  OrderedRepositoryImpl(this.client);
  final CustomClient client;
  CartResponse _cartResponse = CartResponse(
      id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  final MethodChannel _channel =
      const MethodChannel('com.range.takk/callIntent');

  @override
  Future<void> addTipOrder(String sum, bool isProcent) async {
    Map<String, dynamic> map = {};
    if (isProcent) {
      map['tip_percent'] = int.parse(sum);
    } else {
      map['tip'] = sum;
    }
    var response = await client.post(Url.addTipOrder);
    if (response.isSuccessful) {
      _cartResponse = CartResponse.fromJson(jsonDecode(response.body));
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getEmpOrders');
    }
  }

  @override
  Future<Map<dynamic, dynamic>?> nativePay(String key, double sum) async {
    return await _channel
        .invokeMethod("nativePay", {"clientSecret": key, "amount": sum});
  }

  @override
  Future<String> createOrder(
      String time, String paymentType, String? cardId) async {
    var response = await client.post(Url.createOrder);
    if (response.isSuccessful) {
      if (paymentType != '1') {
        return response.body;
      } else {
        String key = jsonDecode(response.body)['client_secret'];
        return key;
      }
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'createOrder');
    }
  }

  @override
  CartResponse get cartResponse => _cartResponse;
}
