import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/domain/repositories/order_info_repository.dart';


class OrderInfoRepositoryImpl extends OrderInfoRepository {
  OrderInfoRepositoryImpl(this.client);

  final CustomClient client;
  EmpOrderModel? _empOrderModel = EmpOrderModel();

  @override
  Future<void> getEmpOrder(int id) async {
    var response = await client.get(Url.getEmpOrder(id));
    if (response.isSuccessful) {
      _empOrderModel = EmpOrderModel.fromJson(jsonDecode(response.body));
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getEmpOrder');
    }
  }

  @override
  Future<void> setChangeStateEmpOrder(List<int> id, bool isKitchen) async {
    var response = await client.post(Url.setChangeStateEmpOrder(isKitchen),
        body: jsonEncode({'order_items': id}), headers: {'Content-Type': 'application/json'});
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'setChangeStateEmpOrder');
    }
  }

  @override
  Future<void> changeStatusOrder(int id) async {
    var response = await client.put(Url.changeStatusOrder(id));
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'changeStatusOrder');
    }
  }

  @override
  EmpOrderModel? get empOrderModel => _empOrderModel;
}
