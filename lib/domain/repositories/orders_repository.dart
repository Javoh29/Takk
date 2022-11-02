import 'package:flutter/cupertino.dart';
import 'package:takk/data/models/emp_order_model.dart';

abstract class OrdersRepository {
  Future<void> getEmpOrders(String state);
  Future<void> setEmpAck(int id);

  List<EmpOrderModel> get listNewOrders;

  List<EmpOrderModel> get listReadyOrders;

  List<EmpOrderModel> get listRefundOrders;

  set listReadyOrders(List<EmpOrderModel> value);

  set listRefundOrders(List<EmpOrderModel> value);

  set listNewOrders(List<EmpOrderModel> value);
}
