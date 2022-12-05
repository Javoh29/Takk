import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/presentation/widgets/cafe_item.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../routes/routes.dart';
import '../../../widgets/loading_dialog.dart';

class PickCafeViewModel extends BaseViewModel {
  PickCafeViewModel({
    required super.context,
    required this.cafeRepository,
    required this.localViewModel,
  });

  CafeRepository cafeRepository;
  LocalViewModel localViewModel;

  Future? dialog;

  final String tag = 'cafeItemFunc';

  cafeItemFunc() async {
    safeBlock(() {
      cafeRepository.cafeTileList
          .map(
            (e) => CafeItemWidget(
              model: e,
              padding: const EdgeInsets.only(
                  bottom: 10, top: 5, left: 15, right: 15),
              tap: pop(),
              isCashier: localViewModel.isCashier,
              isLoad: isBusy(tag: e.id.toString()),
              onTapFav: () => navigateTo(
                Routes.cafePage,
                arg: {'cafe_model': e, 'isFav': false},
              ),
            ),
          )
          .toList();
      setSuccess(tag: tag);
    }, callFuncName: 'cafeItemFunc', tag: tag);
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
}
