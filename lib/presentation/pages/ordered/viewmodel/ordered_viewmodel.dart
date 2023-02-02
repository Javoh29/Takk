import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../domain/repositories/tariffs_repository.dart';
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

  getPeymentType() {
    safeBlock(() async {
      final result = await cartRepository.getLastPaymentType();
      final TariffsRepository tariffsRepository = locator.get();
      if (tariffsRepository.cardList.isEmpty) {
        await tariffsRepository.getUserCards();
      }
      String cardName = '';
      if (result.cardId != null) {
        final card = tariffsRepository.cardList.firstWhere((element) => element.id == result.cardId);
        cardName = '${card.brand} **** ${card.last4}';
      }
      paymentType = {
        'type': result.cardId != null
            ? '2'
            : result.paymentType == 'balance'
                ? '0'
                : '1',
        'name': result.cardId != null
            ? cardName
            : result.paymentType == 'balance'
                ? 'Cafe budget'
                : Platform.isAndroid
                    ? 'Google pay'
                    : 'Apple pay',
        'id': result.cardId
      };
      setSuccess();
    });
  }

  makePayment(DateTime? costumTime, int curTime) async {
    if (paymentType != null) {
      safeBlock(() async {
        final key = await cartRepository.createOrder(
            costumTime != null
                ? costumTime.millisecondsSinceEpoch.toString()
                : DateTime.now().add(Duration(minutes: curTime)).millisecondsSinceEpoch.toString(),
            paymentType!['type'],
            paymentType!['id']);
        if (paymentType!['type'] == '1') {
          clientSecret = jsonDecode(key)['client_secret'];
          final result =
              await cartRepository.nativePay(clientSecret, double.parse(cartRepository.cartResponse.totalPrice));
          if (result?['success'] != null) {
            setSuccess();
            pop(result: key);
          } else {
            callBackError(result?['err']);
          }
        } else {
          setSuccess();
          pop(result: key);
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
