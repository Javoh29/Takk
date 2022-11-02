import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/domain/repositories/order_info_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class OrderInfoPageViewModel extends BaseViewModel {
  OrderInfoPageViewModel({required super.context, required this.orderModel});

  Future? dialog;
  late OrderInfoRepository orderInfoRepository;
  late EmpOrderModel orderModel;

  late ValueNotifier<bool> notifier;
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
    selectTab = orderInfoRepository.empOrderModel.kitchen!.isEmpty ? 1 : 0;
    isSuccess(tag: "init");
    update = () {
      debugPrint("update");
      Future.delayed(
        Duration.zero,
        () => refresh.currentState!.show(),
      );
      notifier.addListener(update);
    };
  }

  refreshFunc(
    int? id,
  ) {
    safeBlock(() async {
      var value = await orderInfoRepository.getEmpOrder(id ?? 0);
      if (value != null) {
        orderModel = value;
        setSuccess(tag: tag);
      }
    } , callFuncName: 'refreshFunc', tag: tagRefreshFunc);
  }

  setChangeStateEmpOrderFunc(List<int> id, bool isKitchen) async {
    safeBlock(() async {
      await orderInfoRepository.setChangeStateEmpOrder(id, isKitchen);
      setSuccess(tag: tagSetChangeState);
    });
  }
  changeStateOrderFunc(
    int id,
  ) async {
    safeBlock(() async {
      await orderInfoRepository.changeStatusOrder(id);
      setSuccess(tag: tagChangeStatusOrder);
    }, callFuncName: 'changeStateOrderFunc', tag: tagChangeStateOrderFunc);
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
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
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  @override
  void dispose() {
    notifier.removeListener(update);
    super.dispose();
  }
}
