import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/emp_order_model.dart';

class OrderInfoSheetViewModel extends BaseViewModel {
  OrderInfoSheetViewModel({required super.context});

  final String tag = 'OrderInfoPage';
  late EmpOrderModel orderModel;
  final GlobalKey<RefreshIndicatorState> refresh = GlobalKey<RefreshIndicatorState>();  
}
