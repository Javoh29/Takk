import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cart_response.dart';
import '../../../../domain/repositories/latest_orders_repository.dart';
import '../../../widgets/dialog_add_favorite.dart';
import '../../../widgets/loading_dialog.dart';

class LatestOrdersViewModel extends BaseViewModel {
  LatestOrdersViewModel({required super.context, required this.latestOrdersRepository});

  LatestOrdersRepository latestOrdersRepository;
  Future? dialog;

  getUserOrder(String tag) {
    safeBlock(() async {
      await latestOrdersRepository.getUserOrders();
      setSuccess(tag: tag);
    }, callFuncName: 'getUserOrder', tag: tag);
  }

  setOrderLike(String tag, int id, bool lStrike) {
    safeBlock(() async {
      await latestOrdersRepository.setOrderLike(id, lStrike);
      setSuccess(tag: tag);
    }, callFuncName: 'setOrderLike', tag: tag);
  }

  addToCart(int id, bool isFav, String name) {
    safeBlock(() async {
      await locator<CartRepository>().addToCart(id, isFav);
      setCartFov(name);
    }, callFuncName: 'addToCart');
  }

  setCartFov(String name, {int? favID}) {
    safeBlock(() async {
      await locator<CartRepository>().setCartFov(name, favID: favID);
      setSuccess();
      Future.delayed(
          Duration.zero,
          () => showTopSnackBar(
                context!,
                const CustomSnackBar.info(
                  message: 'Favorite has been created',
                ),
              ));
    }, callFuncName: 'setCartFov', inProgress: false);
  }

  setFavorite(String tag, CartResponse modelCart) {
    setOrderLike(tag, modelCart.id, modelCart.like == null ? true : modelCart.like == false);
    modelCart.setLike(modelCart.like == null ? true : modelCart.like == false);
  }

  Future<void> showAddFavorite(CartResponse modelCart) async {
    showAddFavoriteDialog(context!).then(
      (value) {
        if (value is String) {
          addToCart(modelCart.id, false, value);
        }
      },
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
