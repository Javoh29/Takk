import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/order_info_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class OrderInfoPageViewModel extends BaseViewModel {
  OrderInfoPageViewModel(
      {required super.context, required this.orderModel, required this.orderInfoRepository, required this.type});

  Future? dialog;
  final OrderInfoRepository orderInfoRepository;
  late EmpOrderModel orderModel;
  final int type;

  final GlobalKey<RefreshIndicatorState> refresh = GlobalKey<RefreshIndicatorState>();

  late var update;
  int selectTab = 0;

  final String tag = 'OrderInfoPage';
  final String tagRefreshFunc = 'RefreshFunc';
  final String tagChangeStateOrderFunc = 'changeStateOrderFunc';
  final String tagSetChangeState = 'setChangeState';
  final String tagChangeStatusOrder = 'changeStatusOrder';

  bool isSelectAllZero = false;
  bool isSelectAllFirst = false;

  initState() {
    selectTab = orderModel.kitchen!.isEmpty ? 1 : 0;
    update = () {
      debugPrint("update");
      Future.delayed(
        Duration.zero,
        () => refresh.currentState!.show(),
      );
      locator<LocalViewModel>().notifier.addListener(update);
    };
  }

  Future<void> tapSelectAll(bool? value) async {
    List<int> l = [];
    if (selectTab == 0 && orderModel.kitchen!.isNotEmpty) {
      for (var element in orderModel.kitchen!) {
        element.isReady = value;
        l.add(element.id ?? 0);
      }
      isSelectAllZero = value ?? false;
      await setChangeStateEmpOrderFunc(l, selectTab == 0);
      if (isError(tag: tagSetChangeState)) {
        for (var element in orderModel.kitchen!) {
          element.isReady = !value!;
        }
        isSelectAllZero = !value!;
      }
    } else if (selectTab == 1 && orderModel.main!.isNotEmpty) {
      for (var element in orderModel.main!) {
        element.isReady = value;
        l.add(element.id ?? 0);
      }
      isSelectAllFirst = value ?? false;

      await setChangeStateEmpOrderFunc(l, selectTab == 0);
      if (isError(tag: tagSetChangeState)) {
        for (var element in orderModel.kitchen!) {
          element.isReady = !value!;
        }
        isSelectAllFirst = !value!;
      }
      notifyListeners();
    }
  }

  Future<void> refreshFunc(int? id) async {
    safeBlock(() async {
      await orderInfoRepository.getEmpOrder(id ?? 0);
      if (orderInfoRepository.empOrderModel != null) {
        orderModel = orderInfoRepository.empOrderModel!;
        setSuccess(tag: tagRefreshFunc);
      }
    }, callFuncName: 'refreshFunc', tag: tagRefreshFunc);
  }

  Future<void> setChangeStateEmpOrderFunc(List<int> id, bool isKitchen) async {
    safeBlock(() async {
      await orderInfoRepository.setChangeStateEmpOrder(id, isKitchen);
      setSuccess(tag: tagSetChangeState);
    }, callFuncName: "setChangeStateEmpOrderFunc", tag: tagSetChangeState);
  }

  Future<void> changeStateOrderFunc(int id) async {
    safeBlock(() async {
      await orderInfoRepository.changeStatusOrder(id, 'ready');
      setSuccess(tag: tagChangeStateOrderFunc);
    }, callFuncName: 'changeStateOrderFunc', tag: tagChangeStateOrderFunc);
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    Future.delayed(Duration.zero, () {
      if (dialog != null) pop();
    });
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  @override
  void dispose() {
    locator<LocalViewModel>().notifier.removeListener(update);
    super.dispose();
  }
}
