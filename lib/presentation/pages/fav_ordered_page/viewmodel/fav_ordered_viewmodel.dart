import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../routes/routes.dart';
import '../../../widgets/loading_dialog.dart';

class FavOrderedViewModel extends BaseViewModel {
  FavOrderedViewModel({required super.context, required this.cartResponse, required this.cafeRepository});

  final String tag = 'FavOrderedPage';
  final String tagCheckTimestampFunc = 'checkTimestampFunc';
  final String tagaddToCartFunc = 'tagaddToCartFunc';

  CafeModel cafeModel = CafeModel();
  CafeRepository cafeRepository;
  CartResponse cartResponse;
  int selectTab = 0;
  int curTime = 5;
  DateTime? costumTime;
  Future? dialog;

  initState() {
    for (var element in cafeRepository.cafeTileList) {
      if (cartResponse.cafe!.id == element.id) {
        cafeModel = element;
      }
    }
  }

  checkTimestampFunc(int cafeId, bool isFav) {
    safeBlock(() async {
      double t = 0;
      if (costumTime != null) {
        t = costumTime!.millisecondsSinceEpoch / 1000;
      } else {
        t = DateTime.now().add(Duration(minutes: curTime)).millisecondsSinceEpoch / 1000;
      }
      final result = await cafeRepository.checkTimestamp(cafeId, t.toInt());
      if (result) {
        addToCartFunc(cartResponse.id, isFav);
      } else {
        setSuccess(tag: tagCheckTimestampFunc);
      }
    }, callFuncName: 'checkTimestampFunc', tag: tagCheckTimestampFunc, isChange: false);
  }

  addToCartFunc(int id, bool isFav) {
    safeBlock(() async {
      await locator<CartRepository>().addToCart(id, isFav);
      setSuccess(tag: tagCheckTimestampFunc);
      navigateTo(Routes.orderedPage, arg: {'curTime': curTime, 'costumTime': costumTime, 'isPickUp': selectTab == 0})
          .then((value) {
        if (value != null) {
          Future.delayed(
            Duration.zero,
            () => navigateTo(
              Routes.confirmPage,
              arg: {
                'data': jsonDecode(value.toString()),
              },
            ),
          );
        }
      });
    }, callFuncName: 'addToCartFunc', tag: tagCheckTimestampFunc, isChange: false, inProgress: false);
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
