import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/fav_ordered_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../widgets/loading_dialog.dart';

class FavOrderedViewModel extends BaseViewModel {
  FavOrderedViewModel(
      {required super.context,
      required this.model,
      required this.cafeRepository,
      required this.favOrderedRepository});

  final String tag = 'FavOrderedPage';
  final String tagCheckTimestampFunc = 'checkTimestampFunc';
  final String tagaddToCartFunc = 'tagaddToCartFunc';

  CafeModel cafeModel = CafeModel();
  CafeRepository cafeRepository;
  FavOrderedRepository favOrderedRepository;
  CartResponse model;
  int selectTab = 0;
  int curTime = 5;
  DateTime? costumTime;
  Future? dialog;

  initState() {
    for (var element in cafeRepository.cafeTileList) {
      if (model.cafe!.id == element.id) {
        cafeModel = element;
      }
    }
  }

  checkTimestampFunc(int cafeId, int time) {
    safeBlock(() async {
      await favOrderedRepository.checkTimestamp(cafeId, time);
      setSuccess(tag: tagCheckTimestampFunc);
    }, callFuncName: 'checkTimestampFunc', tag: tagCheckTimestampFunc);
  }

  addToCartFunc(int id, bool isFav) {
    safeBlock(() async {
      await favOrderedRepository.addToCart(id, isFav);
      setSuccess(tag: tagaddToCartFunc);
    }, callFuncName: 'addToCartFunc', tag: tagaddToCartFunc);
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
