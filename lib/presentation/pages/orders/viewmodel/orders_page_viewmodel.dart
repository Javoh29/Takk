import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/orders_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class OrdersPageViewModel extends BaseViewModel {
  OrdersPageViewModel({required super.context, required this.ordersRepository});

  Future? dialog;

  final String tag = 'OrdersPage';
  final String tagSetEmpAckFunc = 'setEmpAckFunc';
  final String tagGetNewOrders = 'getNewOrders';
  final String tagGetReadyOrders = 'getReadyOrders';
  final String tagGetRefundOrders = 'getRefundOrders';

  final OrdersRepository ordersRepository ;
  bool isNewOrder = false;


  Future<void> getNewOrders() async {
    safeBlock(() async {
      await ordersRepository.getEmpOrders('new');
      isNewOrder = true;
      setSuccess(tag: tagGetNewOrders);
    }, callFuncName: 'getNewOrders', tag: tagGetNewOrders);
  }

  Future<void> getReadyOrders() async {
    safeBlock(() async {
      await ordersRepository.getEmpOrders('ready');
      setSuccess(tag: tagGetReadyOrders);
    }, callFuncName: 'getReadyOrders', tag: tagGetReadyOrders);
  }

  Future<void> getRefundOrders() async {
    safeBlock(() async {
      await ordersRepository.getEmpOrders('refund');
      setSuccess(tag: tagGetRefundOrders);
    }, callFuncName: 'getRefundOrders', tag: tagGetRefundOrders);
  }

  setEmpAckFunc(int id) {
    safeBlock(() async {
      await ordersRepository.setEmpAck(id);
      setSuccess(tag: tagSetEmpAckFunc);
    }, callFuncName: 'setEmpAckFunc', tag: tagSetEmpAckFunc);
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
}
