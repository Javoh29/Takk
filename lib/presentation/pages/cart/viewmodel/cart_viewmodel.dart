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
  Future? dialog;

  getCartListFunc() {
    safeBlock(() async {
      await cartRepository.getCartList();
      setSuccess(tag: tagGetCartListFunc);
    },
        callFuncName: 'getCartListFunc',
        tag: tagGetCartListFunc,
        inProgress: false);
  }

  delCartItemFunc(int id) {
    safeBlock(() async {
      await cartRepository.delCartItem(id);
      getCartListFunc();
    }, callFuncName: 'delCartItemFunc', tag: tagDelCartItemFunc);
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
