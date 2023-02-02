import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cart_response.dart';
import '../../../widgets/loading_dialog.dart';

class FavoriteEditViewModel extends BaseViewModel {
  FavoriteEditViewModel(
      {required super.context, required this.favoriteRepository});

  Future? dialog;
  FavoriteRepository favoriteRepository;
  CartRepository cartRepository = locator<CartRepository>();

  Future<void> addToCart(String tag, int id, bool isFav) async {
    safeBlock(() async {
      cartRepository.cartResponse =
          await favoriteRepository.addToCart(tag, id, isFav);
      setSuccess(tag: tag);
    }, tag: tag);
  }

  Future<void> deleteFavorite(String tag, int id) async {
    safeBlock(() async {
      await favoriteRepository.deleteFavorite(id);
      setSuccess(tag: tag);
    }, tag: tag, callFuncName: 'deleteFavorite', inProgress: false);
  }

  Future<void> setCartFov(String tag, String name, {int? favID}) async {
    if (name.isEmpty) {
      callBackError('Please enter title');
    } else if (cartRepository.cartList.isEmpty) {
      callBackError('Please add product');
    } else {
      safeBlock(() async {
        await favoriteRepository.setCartFov(name, favID: favID);
        showTopSnackBar(
          context!,
          CustomSnackBar.success(
            message: 'Favorite $name successfully saved',
          ),
        );
        setSuccess(tag: tag);
        pop();
      }, tag: tag, callFuncName: 'setCartFov');
    }
  }

  Future<void> getProductInfo(String tag, CartModel cartModel) async {
    safeBlock(() async {
      var m = await favoriteRepository.getProductInfo(tag, cartModel);
      m?.comment = cartModel.instruction;
      m?.sizes.forEach((e) {
        if (e.id == cartModel.productSize) {
          e.mDefault = true;
        } else {
          e.mDefault = false;
        }
      });
      m?.modifiers.forEach((e) {
        for (var m in e.items) {
          bool isCheck = false;
          for (var p in cartModel.productModifiers) {
            if (p.id == m.id) isCheck = true;
          }
          m.mDefault = isCheck;
        }
      });
      m?.count = cartModel.quantity;
      setSuccess(tag: tag);
    });
  }

  Future<void> getCartList(String tag) async {
    safeBlock(() async {
      var response = await favoriteRepository.getCartList();
      if (response['items'].isEmpty) {
        cartRepository.cartList.clear();
        cartRepository.cartResponse =
            CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        cartRepository.cartResponse = CartResponse.fromJson(response);
        cartRepository.cartList.clear();
        for (var element in cartRepository.cartResponse.items) {
          cartRepository.cartList.add(element.id);
        }
      }
      setSuccess(tag: tag);
    }, tag: tag, callFuncName: 'getCartList');
  }

  Future<void> delCartItem(String tag, int id) async {
    safeBlock(() async {
      await favoriteRepository.deleteCartItem(id);
      getCartList(tag);
    }, tag: tag, callFuncName: "delCartItem", inProgress: false);
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
