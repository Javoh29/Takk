import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/repositories/order_info_sheet_repository_impl.dart';
import 'package:takk/domain/repositories/order_info_sheet_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../loading_dialog.dart';

class OrderInfoSheetViewModel extends BaseViewModel {
  OrderInfoSheetViewModel({required super.context});

  final String tag = 'OrderInfoSheet';
  Future? dialog;

  late OrderInfoSheetRepository orderInfoSheetRepository;

  getOrderInfoViewModel(int id) async {
    safeBlock(() async {
      await orderInfoSheetRepository.getOrderInfo(id);
      setSuccess(tag: tag);
    }, callFuncName: "getOrderInfoViewModel", tag: tag);
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