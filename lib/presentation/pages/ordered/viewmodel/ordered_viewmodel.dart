import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../widgets/loading_dialog.dart';

class OrderedViewModel extends BaseViewModel {
  OrderedViewModel({required super.context, required this.cafeRepository, required this.cartRepository});

  var nowDate = DateTime.now();
  var numFormat = NumberFormat('###,###.00', 'en_US');

  Future? dialog;

  CafeRepository cafeRepository;
  CafeModel? cafeModel;
  CartRepository cartRepository;

  Map<dynamic, dynamic>? paymentType;

  String clientSecret = '';
  String time = '';
  final String tag = 'OrderedPage';
  final String tagAddTipOrder = 'addTipOrder';
  final String tagNativePayFunc = 'nativePayFunc';
  final String tagCreateOrderFunc = 'createOrderFunc';

  addTipOrderFunc(String sum, bool isProcent) {
    safeBlock(() async {
      await cartRepository.addTipOrder(sum, isProcent);
      setSuccess(tag: tagAddTipOrder);
    }, callFuncName: 'addTipOrderFunc', tag: tagAddTipOrder, isChange: false);
  }

  makePayment(DateTime? costumTime, int curTime) async {
    if (paymentType != null) {
      safeBlock(() async {
        if (paymentType!['type'] == '1' && clientSecret.isNotEmpty) {
          final result =
              await cartRepository.nativePay(clientSecret, double.parse(cartRepository.cartResponse.totalPrice));
          if (result?['success'] != null) {
            setSuccess();
          } else {
            callBackError(result?['err']);
          }
        } else {
          final key = await cartRepository.createOrder(
              costumTime != null
                  ? costumTime.millisecondsSinceEpoch.toString()
                  : DateTime.now().add(Duration(minutes: curTime)).millisecondsSinceEpoch.toString(),
              paymentType!['type'],
              paymentType!['id']);
          if (paymentType!['type'] == '1') {
            clientSecret = key;
            final result =
                await cartRepository.nativePay(clientSecret, double.parse(cartRepository.cartResponse.totalPrice));
            if (result?['success'] != null) {
              setSuccess();
            } else {
              callBackError(result?['err']);
            }
          } else {
            setSuccess();
            pop(result: key);
          }
        }
      }, isChange: false, callFuncName: 'makePayment');
    } else {
      callBackError('Please select a payment method');
    }
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
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
