import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/orders_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../widgets/loading_dialog.dart';

class OrdersPageViewModel extends BaseViewModel {
  OrdersPageViewModel({required super.context, required this.ordersRepository});

  Future? dialog;

  final String tag = 'OrdersPage';
  final String tagSetEmpAckFunc = 'setEmpAckFunc';
  final String tagGetNewOrders = 'getNewOrders';
  final String tagGetReadyOrders = 'getReadyOrders';
  final String tagGetRefundOrders = 'getRefundOrders';

  final OrdersRepository ordersRepository;
  bool isNewOrder = false;

  Future<void> getNewOrders() async {
    await safeBlock(() async {
      await ordersRepository.getEmpOrders('new');
      isNewOrder = true;
      setSuccess(tag: tagGetNewOrders);
    }, callFuncName: 'getNewOrders', tag: tagGetNewOrders, inProgress: false);
  }

  Future<void> getReadyOrders() async {
    await safeBlock(() async {
      await ordersRepository.getEmpOrders('ready');
      setSuccess(tag: tagGetReadyOrders);
    }, callFuncName: 'getReadyOrders', tag: tagGetReadyOrders, inProgress: false);
  }

  Future<void> getRefundOrders() async {
    await safeBlock(() async {
      await ordersRepository.getEmpOrders('refund');
      setSuccess(tag: tagGetRefundOrders);
    }, callFuncName: 'getRefundOrders', tag: tagGetRefundOrders, inProgress: false);
  }

  setEmpAckFunc(int id, {bool isAlarm = false}) {
    safeBlock(() async {
      await ordersRepository.setEmpAck(id);
      setSuccess(tag: tagSetEmpAckFunc);
      if (isAlarm) {
        Future.delayed(const Duration(milliseconds: 500), () {
          var l = locator<LocalViewModel>().alarm.value;
          l.remove(0);
          locator<LocalViewModel>().alarm.value = l;
          locator<LocalViewModel>().notifier.value = true;
          pop();
        });
      }
    }, callFuncName: 'setEmpAckFunc', tag: tagSetEmpAckFunc);
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
}
