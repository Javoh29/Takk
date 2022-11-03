import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cart_response.dart';
import '../../../../data/models/product_model.dart';
import '../../../widgets/loading_dialog.dart';

class FavoriteEditViewModel extends BaseViewModel {
  FavoriteEditViewModel({required super.context, required this.favoriteRepository});

  Future? dialog;
  FavoriteRepository favoriteRepository;
  LocalViewModel localViewModel = locator<LocalViewModel>();

  Future<void> addToCart(String tag, int id, bool isFav) async {
    safeBlock(() async {
      locator<LocalViewModel>().cartResponse = await favoriteRepository.addToCart(tag, id, isFav);
      setSuccess();
    }, tag: tag);
  }

  Future<void> deleteFavorite(String tag, int id) async {
    safeBlock(() async {
      await favoriteRepository.deleteFavorite(id);
    }, tag: tag, callFuncName: 'deleteFavorite');
    setSuccess();
  }

  Future<void> setCartFov(String tag, String name, {int? favID}) async {
    safeBlock(() async {
      await favoriteRepository.setCartFov(name, favID: favID);
    }, tag: tag, callFuncName: 'setCartFov');
    setSuccess();
  }

  Future<ProductModel?> getProductInfo(String tag, CartModel cartModel) async {
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
    });
    setSuccess();
    return null;
  }

  Future<void> addItemCart(String tag, int cafeId, ProductModel model, int? cardItem) async {
    // setState(tag, 'send');
    // try {
    //   List<int> modList = [];
    //   int s = 0;
    //   model.sizes.forEach((e) {
    //     if (e.mDefault) {
    //       s = e.id;
    //     }
    //   });
    //   model.modifiers.forEach((e) {
    //     e.items.forEach((element) {
    //       if (element.mDefault) {
    //         modList.add(element.id);
    //       }
    //     });
    //   });
    //   Response response;
    //   if (cardItem == null) {
    //     response = await post(Url.setItemCart,
    //         body: jsonEncode({
    //           'cafe': cafeId,
    //           'instruction': model.comment,
    //           'quantity': model.count,
    //           'product': model.id,
    //           'product_size': s,
    //           'product_modifiers': modList
    //         }),
    //         encoding: Encoding.getByName("utf-8"),
    //         headers: {'Authorization': 'JWT ${token!.access}', 'Content-Type': 'application/json'});
    //   } else {
    //     response = await put(Url.putCartItem(cardItem),
    //         body: jsonEncode({
    //           'cafe': cafeId,
    //           'instruction': model.comment,
    //           'quantity': model.count,
    //           'product': model.id,
    //           'product_size': s,
    //           'product_modifiers': modList
    //         }),
    //         encoding: Encoding.getByName("utf-8"),
    //         headers: {'Authorization': 'JWT ${token!.access}', 'Content-Type': 'application/json'});
    //   }
    //   if (response.statusCode == 201 || response.statusCode == 200) {
    //     if (cardItem == null) {
    //       _cartList.add(model.id);
    //       _cartResponse.subTotalPrice += double.parse(jsonDecode(response.body)['sub_total_price']);
    //     } else
    //       await getCartList(tag);
    //     setState(tag, 'success');
    //     return 'Product added to cart';
    //   } else if (response.statusCode == 401) {
    //     await UserProvider().updateToken();
    //     setState(tag, 'err');
    //     return errReset;
    //   } else if (response.body.isNotEmpty && jsonDecode(response.body)['detail'] != null) {
    //     setState(tag, 'err');
    //     return jsonDecode(response.body)['detail'];
    //   } else {
    //     setState(tag, 'err');
    //     return errReset;
    //   }
    // } on SocketException {
    //   setState(tag, 'inet');
    //   return errInternet;
    // } catch (e) {
    //   setState(tag, 'err');
    //   return 'Unknown error $e';
    // }
  }

  Future<void> getCartList(String tag) async {
    safeBlock(() async {
      var response = await favoriteRepository.getCartList();
      if (response['items'].isEmpty) {
        locator<LocalViewModel>().cartList.clear();
        locator<LocalViewModel>().cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      } else {
        locator<LocalViewModel>().cartResponse = CartResponse.fromJson(response);
        locator<LocalViewModel>().cartList.clear();
        for (var element in locator<LocalViewModel>().cartResponse.items) {
          locator<LocalViewModel>().cartList.add(element.id);
        }
      }
    }, tag: tag, callFuncName: 'getCartList');
    setSuccess();
  }

  Future<void> delCartItem(String tag, int id) async {
    safeBlock(() async {
      await favoriteRepository.deleteCartItem(id);
    }, tag: tag, callFuncName: "delCartItem");
    setSuccess();
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
