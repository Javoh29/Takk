import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/company_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class CompaniesViewModel extends BaseViewModel {
  CompaniesViewModel({required super.context, required this.companyRepository});

  CompanyRepository companyRepository;
  Future? dialog;

  Future<void> getCompList(String tag) async {
    safeBlock(
      () async {
        await companyRepository.getCompList();
        setSuccess(tag: tag);
      },
      callFuncName: 'getCompList',
      tag: tag,
    );
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      dialog = showLoadingDialog(context!);
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
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