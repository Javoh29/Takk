import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../config/constants/constants.dart';
import '../../../widgets/loading_dialog.dart';

class TariffsViewModel extends BaseViewModel {
  TariffsViewModel({
    required super.context,
    required this.tariffsRepository,
  });

  Future? dialog;
  final TariffsRepository tariffsRepository;
  final String tag = 'TariffsViewModel';
  int tId = 0;
  int cId = 0;
  bool isAutoFill = false;

  Future<void> getTariffs() async {
    safeBlock(() async {
      await tariffsRepository.getTariffs();
      if (tId == 0 && tariffsRepository.tariffsList.isNotEmpty) {
        tId = tariffsRepository.tariffsList.first.id!;
      }
      if (cId == 0 && tariffsRepository.cardList.isNotEmpty) {
        cId = tariffsRepository.cardList.first.id!;
      }
      setSuccess(tag: tag);
    }, callFuncName: "getTariffs", tag: tag);
  }

  Future<String?> getClientSecretKey(String name) async {
    safeBlock(() async {
      return await tariffsRepository.getClientSecretKey(name);
    }, callFuncName: 'getClientSecretKey');
    return null;
  }

  Future<void> paymentRequestWithCardForm() async {
    final result = await channel.invokeMethod("stripeAddCard");
    try {
      var m = <String, dynamic>{};
      m['id'] = result['id'];
      m['last4'] = result['last4'];
      String? value =
          await tariffsRepository.getClientSecretKey('Card${m['last4']}');
      await confirmSetupIntent(m['id'], value ?? '');
    } catch (e) {
      debugPrint('err: $e');
    }
  }

  Future<void> confirmSetupIntent(String id, String key) async {
    safeBlock(() async {
      final result = await channel.invokeMethod(
          "confirmSetupIntent", {"paymentMethodId": id, "clientSecret": key});
      if (result['success'] != null) {
        await tariffsRepository.getUserCards();
      } else if (result!['success'] == null) {
        callBackError(result['err']);
      }
      setSuccess();
    }, callFuncName: 'confirmSetupIntent');
  }

  Future<String?> setBalancePayment(
      String tag, int tId, int type, int cId) async {
    safeBlock(() async {
      return await tariffsRepository.setBalancePayment(tag, tId, type, cId);
    }, callFuncName: 'setBalancePayment', tag: tag);
    return null;
  }

  Future<void> confirm() async {
    if (cId != 0) {
      Future.delayed(Duration.zero, () {
        showLoadingDialog(context!);
        setBalancePayment(tag, tId, 1, cId).then((value) {
          pop();
          if (value != null) {
            pop();
          } else {
            callBackError("Error in confirm");
          }
        });
      });
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
