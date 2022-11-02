import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/domain/repositories/orders_repository.dart';

import '../../config/constants/urls.dart';
import '../../core/services/custom_client.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  late CustomClient customClient;
  late List<EmpOrderModel> _listNewOrders;

  late List<EmpOrderModel> _listReadyOrders;

  late List<EmpOrderModel> _listRefundOrders;

  @override
  Future<void> getEmpOrders(String state) async {
    var response = await get(
      Url.getEmpOrders(state),
    );
    if (response.isSuccessful) {
      switch (state) {
        case "new":
          listNewOrders = [
            for (final item in jsonDecode(response.body)['results']) EmpOrderModel.fromJson(item),
          ];
          break;
        case "ready":
          listReadyOrders = [
            for (final item in jsonDecode(response.body)['results']) EmpOrderModel.fromJson(item),
          ];
          break;
        case "refund":
          listRefundOrders = [
            for (final item in jsonDecode(response.body)['results']) EmpOrderModel.fromJson(item),
          ];
          break;
      }
    }
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getEmpOrders');
  }

  @override
  Future<void> setEmpAck(int id) async {
    var response = await get(Url.setEmpAck(id));
    if(!response.isSuccessful) {
      throw VMException(response.body.parseError(), response: response, callFuncName: 'setEmpAck');
    }
  }

  @override
  List<EmpOrderModel> get listNewOrders => _listNewOrders;

  @override
  List<EmpOrderModel> get listReadyOrders => _listReadyOrders;

  @override
  List<EmpOrderModel> get listRefundOrders => _listRefundOrders;

  @override
  set listNewOrders(List<EmpOrderModel> value) => _listNewOrders = value;

  @override
  set listReadyOrders(List<EmpOrderModel> value) => _listReadyOrders = value;

  @override
  set listRefundOrders(List<EmpOrderModel> value) => _listRefundOrders = value;
}
