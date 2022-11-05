import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../config/constants/constants.dart';
import '../../../widgets/loading_dialog.dart';

class PaymentViewModel extends BaseViewModel {
  PaymentViewModel({required super.context, required this.tariffsRepository, required this.userRepository});
  TariffsRepository tariffsRepository;
  UserRepository userRepository;
  Future? dialog;
  getUserCards() {
    safeBlock(() async {
      await tariffsRepository.getUserCards();
      setSuccess();
    });
  }

  getUserData() {
    safeBlock(() async {
      await userRepository.getUserData();
      setSuccess();
    });
  }

  Future<void> paymentRequestWithCardForm() async {
    final result = await channel.invokeMethod("stripeAddCard");
    try {
      var m = <String, dynamic>{};
      m['id'] = result['id'];
      m['last4'] = result['last4'];
      String? value = await tariffsRepository.getClientSecretKey('Card${m['last4']}');
      await confirmSetupIntent(m['id'], value ?? '');
    } catch (e) {
      debugPrint('err: $e');
    }
  }

  Future<void> confirmSetupIntent(String id, String key) async {
    safeBlock(() async {
      final result = await channel.invokeMethod("confirmSetupIntent", {"paymentMethodId": id, "clientSecret": key});
      if (result['success'] != null) {
        await tariffsRepository.getUserCards();
      } else if (result!['success'] == null) {
        callBackError(result['err']);
      }
    }, callFuncName: 'confirmSetupIntent');
  }

  Future<void> getIsGooglePay() async {
    if (Platform.isAndroid) {
      final result = await channel.invokeMethod("isGooglePay");
      if (result != null && result) {
        pop(result: {'name': 'Google pay', 'type': '1'});
      } else {
        callBackError('You cannot pay from Google Pay for now');
      }
    } else {
      pop(result: {'name': 'Apple pay', 'type': '1'});
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

  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }
}
