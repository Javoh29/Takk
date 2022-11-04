import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:takk/domain/repositories/ordered_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../widgets/loading_dialog.dart';

class OrderedViewModel extends BaseViewModel {
  OrderedViewModel(
      {required super.context,
      required this.cafeRepository,
      required this.cartRepository,
      required this.orderedRepository});

  var nowDate = DateTime.now();
  var numFormat = NumberFormat('###,###.00', 'en_US');

  Future? dialog;

  CafeRepository cafeRepository;
  CafeModel? cafeModel;
  CartRepository cartRepository;
  OrderedRepository orderedRepository;

  Map<dynamic, dynamic>? paymentType;

  String clientSecret = '';
  String time = '';
  final String tag = 'OrderedPage';
  final String tagAddTipOrder = 'addTipOrder';
  final String tagNativePayFunc = 'nativePayFunc';
  final String tagCreateOrderFunc = 'createOrderFunc';

  addTipOrderFunc(String sum, bool isProcent) {
    safeBlock(
      () async {
        await orderedRepository.addTipOrder(sum, isProcent);
        setSuccess(tag: tagAddTipOrder);
      },
      callFuncName: 'addTipOrderFunc',
      tag: tagAddTipOrder,
    );
  }

  nativePayFunc(String key, double sum) {
    safeBlock(
      () async {
        await orderedRepository.nativePay(key, sum);
        setSuccess(tag: tagNativePayFunc);
      },
      callFuncName: 'nativePayFunc',
      tag: tagNativePayFunc,
    );
  }

  createOrderFunc(String times, String paymentType, String? cardId) {
    safeBlock(
      () async {
        orderedRepository.createOrder(times, paymentType, cardId);
        setSuccess(tag: tagCreateOrderFunc);
      },
      callFuncName: 'createOrderFunc',
      tag: tagCreateOrderFunc,
    );
  }

  makePayment(DateTime? costumTime, int curTime) async {
    if (isBusy(tag: tagAddTipOrder)) {
      if (paymentType != null) {
        if (paymentType!['type'] == '1' && clientSecret.isNotEmpty) {
          await nativePayFunc(clientSecret, double.parse(cartRepository.cartResponse.totalPrice));
          if (orderedRepository.result!['success'] != null) {
            pop();
          }
        } else {
          Future.delayed(
            Duration.zero,
            () async {
              await createOrderFunc(
                      costumTime != null
                          ? costumTime.millisecondsSinceEpoch.toString()
                          : DateTime.now().add(Duration(minutes: curTime)).millisecondsSinceEpoch.toString(),
                      paymentType!['type'],
                      paymentType!['id'])
                  .then(
                (value) async {
                  pop();
                  if (paymentType!['type'] == '1') {
                    clientSecret = value;
                    
                    await nativePayFunc(clientSecret, double.parse(cartRepository.cartResponse.totalPrice));
                    if (value!['success'] != null) {
                      pop();
                    }
                  } else {
                    if (isSuccess(tag: tagAddTipOrder)) {
                      pop();
                    }
                  }
                },
              );
            },
          );
        }
      }
    }
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
