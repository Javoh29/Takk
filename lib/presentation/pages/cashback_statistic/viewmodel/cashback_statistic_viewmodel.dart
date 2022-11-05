import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cashback_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class CashbackStatisticViewModel extends BaseViewModel {
  CashbackStatisticViewModel(
      {required super.context, required this.cashbackRepository});

  CashbackRepository cashbackRepository;

  final Duration animDuration = const Duration(milliseconds: 250);
  final String tag = 'CashbackStaticPage';
  int selectPeriod = 0;
  int touchedIndex = -1;
  bool isPlaying = false;
  Future? dialog;


  getInit() {
    safeBlock(() async {
      selectPeriod == 0
          ? cashbackRepository.getCashbackStatistics()
          : cashbackRepository.getCashbackList(selectPeriod);
      setSuccess(tag: tag);
    }, callFuncName: 'getInit', tag: tag);
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
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}