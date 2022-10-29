import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/domain/repositories/order_info_repository.dart';

class OrderInfoPageViewModel extends BaseViewModel {
  OrderInfoPageViewModel({required super.context});
  late EmpOrderModel empOrderModel;
  late OrderInfoRepository orderInfoRepository;

  late ValueNotifier<bool> notifier;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  late var update;

  int _selectTab = 0;

  final String tag = 'OrderInfoPage';

  bool _isSelectAllZero = false;
  bool _isSelectAllFIrst = false;

  initState(
    EmpOrderModel orderModel,
  ) {
    empOrderModel = orderModel;
    _selectTab = orderModel.kitchen!.isEmpty ? 1 : 0;
    update = () {
      Future.delayed(
        Duration.zero,
        () => _refresh.currentState!.show(),
      );
      notifier.addListener(update);
    };
  }

  @override
  void dispose() {
    notifier.removeListener(update);
    super.dispose();
  }

  Future<void> refreshFunc(int? id, BuildContext context) async {
    safeBlock(() async {
      var value = await orderInfoRepository.getEmpOrder(id ?? 0);
      if (value != null) {
        empOrderModel = value;
      }
    });
  }

  GlobalKey<RefreshIndicatorState> get refresh => _refresh;
  int get selectTab => _selectTab;
  bool get isSelectAllZero => _isSelectAllZero;
  bool get isSelectAllFIrst => _isSelectAllFIrst;

  set selectTab(int val) => _selectTab = selectTab;
  set isSelectAllZero(bool val) => _isSelectAllZero = isSelectAllZero;
  set isSelectAllFIrst(bool val) => _isSelectAllFIrst = isSelectAllFIrst;
}
