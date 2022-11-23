import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/constants.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/domain/repositories/refund_order_repository.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/emp_order_model.dart';
import '../../../widgets/loading_dialog.dart';

class RefundOrderViewModel extends BaseViewModel {
  RefundOrderViewModel(
      {required super.context, required this.items, required this.totalSum});

  final String tag = 'RefundOrderPage';
  final String totalSum;
  final List<Items> items;
  List<int> selectId = [];
  Future? dialog;
  bool isAmount = false;
  bool isTotalAmount = true;
  String amount = '0.00';
  String comm = '';
  double sum = 0.0;

  initState() {
    for (var element in items) {
      selectId.add(element.id!);
    }
  }

  totalAmountChange(bool value) {
    isTotalAmount = value;
    if (value) {
      amount = totalSum;
    }
    notifyListeners();
  }

  checkTotalAmount(bool? value, int index) {
    if (value!) {
      selectId.add(items[index].id!);
    } else {
      selectId.remove(items[index].id!);
    }
    if (selectId.isNotEmpty) {
      if (selectId.length == items.length) {
        isTotalAmount = true;
      } else {
        isTotalAmount = false;
      }
    } else {
      isTotalAmount = true;
    }
    notifyListeners();
  }

  textFieldSetState(String value) {
    if (value.isEmpty) {
      amount = '0.00';
      isAmount = false;
      isTotalAmount = true;
    } else {
      isTotalAmount = false;
      isAmount = true;
      amount = numFormat.format(double.parse(value));
    }
    notifyListeners();
  }

  void refundOrderFunc(int orderId) {
    safeBlock(
      () async {
        if (comm.isNotEmpty) {
          await locator<RefundOrderRepository>()
              .refundOrder(orderId, comm, isTotalAmount, amount, selectId);
          Navigator.popUntil(context!, (route) {
            return route.settings.name! == Routes.ordersPage;
          });
        } else {
          callBackError('Please, write the reason for refund');
        }
        setSuccess();
      },
      callFuncName: 'refundOrderFunc',
    );
  }

  sumOfTotalPrice() {
    sum = 0.0;
    for (var element in items) {
      if (selectId.contains(element.id)) {
        sum += double.parse(element.totalPrice ?? '0.0');
      }
    }
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
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
