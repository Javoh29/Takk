import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class QrcodeViewModel extends BaseViewModel {
  QrcodeViewModel({required super.context});

  Future? dialog;

  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final String tagOnQRViewCreated = "onQRViewCreated";

  void onPermissionSet(QRViewController ctrl, bool p) {
    if (!p) {
      showTopSnackBar(
        context!,
        const CustomSnackBar.info(
          message: 'no Permission',
        ),
      );
    }
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.first.then((value) {
      safeBlock(() {
        String tel = jsonDecode(value.code ?? '')['phone'];
        Future.delayed(
          Duration.zero,
          () => pop(result: tel),
        );
        setSuccess(tag: tagOnQRViewCreated);
      }, callFuncName: 'onQRViewCreated', tag: tagOnQRViewCreated);
    });
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
