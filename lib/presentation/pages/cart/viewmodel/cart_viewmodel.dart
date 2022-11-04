import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class CartViewModel extends BaseViewModel {
  CartViewModel({required super.context, required this.cartRepository});

  final String tag = 'CartPage';
  final String tagGetCartListFunc = 'getCartListFunc';
  final String tagDelCartItemFunc = 'delCartItemFunc';
  CartRepository cartRepository;
  var numFormat = NumberFormat('###,###.00', 'en_US');

  Future? dialog;

  getCartListFunc() {
    safeBlock(
      () async {
        await cartRepository.getCartList();
        isSuccess(tag: tagGetCartListFunc);
      },
      callFuncName: 'getCartListFunc',
      tag: tagGetCartListFunc,
    );
  }

  delCartItemFunc(int id) {
    safeBlock(() async {
      await cartRepository.delCartItem(id);
      setSuccess(tag: tagDelCartItemFunc);
    }, callFuncName: 'delCartItemFunc', tag: tagDelCartItemFunc);
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
