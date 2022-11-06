import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/company_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class CompaniesViewModel extends BaseViewModel {
  CompaniesViewModel({required super.context, required this.companyRepository});

  CompanyRepository companyRepository;
  Future? dialog;

  getCompList(String tag) {
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
