import 'package:jbaza/jbaza.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../domain/repositories/latest_orders_repository.dart';
import '../../../widgets/dialog_add_favorite.dart';
import '../../../widgets/loading_dialog.dart';

class LatestOrdersViewModel extends BaseViewModel {
  LatestOrdersViewModel({required super.context, required this.latestOrdersRepository});

  LatestOrdersRepository latestOrdersRepository;
  Future? dialog;

  Future<void> getUserOrder(String tag) async {
    safeBlock(() async {
      await latestOrdersRepository.getUserOrders();
      setSuccess(tag: tag);
    }, callFuncName: 'getUserOrder', tag: tag);
  }

  Future<void> setOrderLike(String tag, int id, bool lStrike) async {
    safeBlock(() async {
      await latestOrdersRepository.setOrderLike(id);
      setSuccess(tag: tag);
    }, callFuncName: 'setOrderLike', tag: tag);
  }

  Future<void> addToCart(String tag, int id, bool isFav) async {
    safeBlock(() async {
      await latestOrdersRepository.addToCart(id, isFav);
    }, callFuncName: 'addToCart', tag: tag);
  }

  Future<void> setCartFov(String tag, String name, {int? favID}) async {
    safeBlock(() async {
      await latestOrdersRepository.setCartFov(name, favID: favID);
      setSuccess(tag: tag);
    }, callFuncName: 'setCartFov', tag: tag);
  }

  Future<void> setFavorite(String tag, var modelCart) async {
    modelCart.setLike(modelCart.like == null ? true : !modelCart.like!);
    notifyListeners();
    setOrderLike(tag, modelCart.id, modelCart.like == null ? true : !modelCart.like!).then((value) {});
  }

  Future<void> showAddFavorite(String tagAddToCart, String tagSetCartFov, var modelCart) async {
    showAddFavoriteDialog(context!).then(
      (value) {
        if (value is String) {
          Future.delayed(
            Duration.zero,
            () {
              addToCart(tagAddToCart, modelCart.id, false).then(
                (_) {
                  if (isSuccess(tag: tagAddToCart)) {
                    setCartFov(tagSetCartFov, value).then(
                      (v) {
                        pop();
                        if (isSuccess(tag: tagSetCartFov)) {
                          showTopSnackBar(
                            context!,
                            const CustomSnackBar.info(
                              message: 'Favorite has been created',
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              );
            },
          );
        }
      },
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
