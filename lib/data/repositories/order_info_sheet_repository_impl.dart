import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/order_info_sheet_repository.dart';

class OrderInfoSheetRepositoryImpl extends OrderInfoSheetRepository {
  late CustomClient customClient;
  late CartResponse _cartResponse;
  @override
  Future<CartResponse?> getOrderInfo(int id) async {
    var response = await get(
      Url.getOrderInfo(id),
    );
    if (response.isSuccessful) {
      _cartResponse = CartResponse.fromJson(
        jsonDecode(response.body),
      );      
    }
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getOrderInfo');
  }

  CartResponse get cartResponse => _cartResponse;
}
