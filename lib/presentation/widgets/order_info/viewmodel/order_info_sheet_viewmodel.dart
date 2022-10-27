import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/emp_order_model.dart';

class OrderInfoSheetViewModel extends BaseViewModel {
  OrderInfoSheetViewModel({required super.context});

  final String tag = 'OrderInfoPage';
  late EmpOrderModel orderModel;
  final GlobalKey<RefreshIndicatorState> refresh = GlobalKey<RefreshIndicatorState>();
  int selectTab = 0;
  bool isSelectAllZero = false;
  bool isSelectAllOne = false;
  late var update;

  Future<EmpOrderModel?> getEmpOrder(int id) async {}

  void initState(EmpOrderModel orderModels) {
    orderModel = orderModels;
    selectTab = orderModels.kitchen!.isEmpty ? 1 : 0;
  }
}
