import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl(this.client);
  late CustomClient client;

  @override
  Future<EmpOrderModel?> getOrder(String tag, int id) async {
    var response = await client.get(
      Url.getEmpOrder(id),
    );
    if (response.isSuccessful) {
      locator<LocalViewModel>().orderList = [
        for (final item in jsonDecode(response.body)) EmpOrderModel.fromJson(item),
      ];
    } 
    // else if () {
      
    // }
    throw VMException(response.body.parseError(), response: response, callFuncName: "getOrder");
  }
}
