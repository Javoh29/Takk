import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/domain/repositories/message_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class MessagesViewModel extends BaseViewModel {
  MessagesViewModel({required super.context, required this.messageRepository});

  MessageRepository messageRepository;
  final GlobalKey<RefreshIndicatorState> refNew =
      GlobalKey<RefreshIndicatorState>();

  String curDate = '';
  Future? dialog;

  initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => refNew.currentState!.show(),
    );
  }

  Future<void> getMessages(String tag) async {
    safeBlock(
      () async {
        await messageRepository.getMessage();
        setSuccess(tag: tag);
      },
      callFuncName: 'getMessages',
      tag: tag,
    );
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
