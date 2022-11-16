import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/company_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class EmtPointsViewModel extends BaseViewModel {
  EmtPointsViewModel({required super.context, required this.companyRepository});
  Future? dialog;

  final String tag = 'EmtPointsPage';
  final String tagCompanyLogo = 'companyLogo';
  final String tagGivePointsFunc = 'givePointsFunc';
  int point = 0;
  String? phone;

  CompanyRepository companyRepository;

  companyLogo() {
    safeBlock(
      () async {
        await companyRepository.getCompanyModel();
      },
      callFuncName: 'companyLogo',
      tag: tagCompanyLogo,
    );
  }

  givePointsFunc(int points, String phone, int id) {
    safeBlock(
      () async {
        await companyRepository.givePoints(points, phone, id);
      },
      callFuncName: 'givePointsFunc',
      tag: tagGivePointsFunc,
    );
  }

  submitFunc() {
    if (point == 0) {
      Future.delayed(
        Duration.zero,
        () => showTopSnackBar(
          context!,
          const CustomSnackBar.info(
            message: 'Please, select points',
          ),
        ),
      );
    } else if (phone == null) {
      Future.delayed(
        Duration.zero,
        () => showTopSnackBar(
          context!,
          const CustomSnackBar.info(
            message: 'Please, enter the user\'s phone number',
          ),
        ),
      );
    } else {
      givePointsFunc(point, phone!, companyLogo()!.id ?? 0).then(
        (value) {
          pop();
          if (isSuccess(tag: tagGivePointsFunc)) {
            Future.delayed(
              Duration.zero,
              () => showTopSnackBar(
                context!,
                const CustomSnackBar.info(
                  message: 'Success',
                ),
              ),
            );
          }
        },
      );
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
