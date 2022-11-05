import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/constants.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/domain/repositories/refund_order_repository.dart';

import '../../config/constants/urls.dart';
import '../../core/services/custom_client.dart';

class RefundOrderRepositoryImpl extends RefundOrderRepository {
  RefundOrderRepositoryImpl(this.client);
  final CustomClient client;

  @override
  Future<void> refundOrder(String tag, int orderID, String comm, bool isOrder,
      String amount, List<int> items) async {
    var map = jsonEncode({
      'order': orderID,
      if (isOrder)
        'order_refund': true
      else if (amount != "0.00")
        'amount': amount
      else
        'items': items,
      'description': comm
    });
    var response = await client.post(Url.setRefundOrder,
        body: map, headers: headerContent);
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(),
          callFuncName: 'refundOrder');
    }
  }
}
