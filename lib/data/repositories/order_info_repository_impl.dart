import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/domain/repositories/order_info_repository.dart';

class OrderInfoRepositoryImpl extends OrderInfoRepository {
  late CustomClient client;
  late EmpOrderModel _empOrderModel;
  @override
  Future<EmpOrderModel?> getEmpOrder(int id) async {
    var response = await client.get(
      Url.getEmpOrder(id),
    );
    if (response.isSuccessful) {
      _empOrderModel = jsonDecode(response.body);      
    }
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getEmpOrder');
  }

  
}
