import 'package:flutter/cupertino.dart';
import 'package:jbaza/jbaza.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/presentation/pages/cafe/widgets/custom_time_bottom_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/ctg_model.dart';
import '../../../../data/models/product_model.dart';
import '../../../../domain/repositories/cart_repository.dart';
import '../../../widgets/loading_dialog.dart';
import '../../../widgets/sign_in_dialog.dart';
import '../widgets/add_gds_sheet.dart';

class CafeViewModel extends BaseViewModel {
  CafeViewModel({required this.cafeRepository, required super.context});
  CafeRepository cafeRepository;

  Future? dialog;
  DateTime? custumTime;
  int curTime = 5;
  List<dynamic> cafeProducts = [];
  List<ProductModel> listProducts = [];
  List<ProductModel> listSearchProducts = [];
  bool isSearch = false;
  ProductModel? bottomSheetModel;
  Map<int, int> chossens = Map();
  int selectTab = 0;
  Map<int, int> mapIndex = Map();

  Future<List<ProductModel>> getCafeProductList(String tag, int cafeId) async {
    safeBlock(() async {
      var data = await cafeRepository.getCafeProductList(tag, cafeId);
      locator<LocalViewModel>().headCtgList = [for (final item in data['categories']) CtgModel.fromJson(item)];
      // cafeProducts.clear();
      for (final item in data['list']) {
        cafeProducts.add(item);
        if (item['type'] == 2) {
          for (final e in item['products']) {
            listProducts.add(ProductModel.fromJson(e));
          }
        }
      }
      cafeRepository.listProducts = listProducts;
      setSuccess(tag: tag);
    }, callFuncName: 'getCafeProductList', tag: tag);

    return listProducts;
  }

  Future<void> getCartList(String tag) async {
    safeBlock(() async {
      await locator<CartRepository>().getCartList();
      setSuccess(tag: tag);
    }, callFuncName: 'getCartList', inProgress: false);
  }

  void basketFunction(String tag, BuildContext context, CafeModel cafeModel) async {
    if (locator<LocalViewModel>().isGuest) {
      showSignInDialog(context);
    } else {
      safeBlock(() async {
        // showLoadingDialog(context);
        double t = 0;
        if (custumTime != null) {
          t = custumTime!.millisecondsSinceEpoch / 1000;
        } else {
          t = DateTime.now().add(Duration(minutes: curTime)).millisecondsSinceEpoch / 1000;
        }
        bool request = await cafeRepository.checkTimestamp(tag, cafeModel.id!, t.toInt());
        pop();

        if (request) {
          //TO DO
          // navigateTo()
          // Navigator.pushNamed(context, Routes.cartPage, arguments: {
          //   'curTime': _curTime,
          //   'custumTime': custumTime,
          //   'isPickUp': _selectTab == 0
          // }).then((v) {
          //   if (v is bool) {
          //     Navigator.pop(context);
          //   }
          // });
        } else {
          // ignore: use_build_context_synchronously
          showTopSnackBar(context, const Text('Please choose another pickup time!'));
        }
      }, callFuncName: 'basketFunction', inProgress: false);
    }
  }

  void filter(String text) {
    isSearch = text.isNotEmpty;
    listSearchProducts.clear();
    if (text.length > 2) {
      if (text.isNotEmpty) {
        for (var e in listProducts) {
          if (e.name!.toLowerCase().contains(text.toLowerCase())) {
            listSearchProducts.add(e);
          }
        }
      }
    }

    listSearchProducts;
    notifyListeners();
  }

  void cartListFunction({required String tag, required BuildContext context, required CafeModel cafeModel}) {
    safeBlock(() async {
      if (locator<LocalViewModel>().isGuest) {
        showSignInDialog(context);
      } else {
        Future.delayed(Duration.zero, () async {
          showLoadingDialog(context);
          double t = 0;
          if (custumTime != null) {
            t = custumTime!.millisecondsSinceEpoch / 1000;
          } else {
            t = DateTime.now().add(Duration(minutes: curTime)).millisecondsSinceEpoch / 1000;
          }
          bool isAvailable = await cafeRepository.checkTimestamp(tag, cafeModel.id!, t.toInt());

          if (isAvailable) {
            //TO DO
            // Navigator.pushNamed(context, Routes.cartPage, arguments: {
            //   'curTime': _curTime,
            //   'custumTime': custumTime,
            //   'isPickUp': _selectTab == 0
            // });
          } else {
            callBackError('Please choose another pickup time!');
          }
        });
      }
      setSuccess(tag: tag);
    }, callFuncName: 'cartListFunction');
  }

  void cafeProductItemFunction({
    required BuildContext context,
    required bool isFavorite,
    required bool available,
    required CafeModel cafeModel,
    required ProductModel productModel,
  }) {
    if (locator<LocalViewModel>().isCashier) {
      // setChangeState(e.id, !e.available);
    } else if (isFavorite || available) {
      showCupertinoModalBottomSheet(
          context: context,
          expand: true,
          builder: (context) => AddGdsSheet(
                cafeId: cafeModel.id!,
                productModel: productModel,
              )).then((value) {
        if (isFavorite && value is bool) {
          pop();
        }
      });
    }
  }

  void getProductInfo(String tag, CartModel cartModel, {bool? isload}) {
    safeBlock(() async {
      bottomSheetModel = await cafeRepository.getProductInfo(tag, cartModel);
    }, callFuncName: 'getProductInfo', inProgress: isload ?? false);
  }

  void funcOfRemoveCount() {
    if (bottomSheetModel!.count > 1) {
      bottomSheetModel!.count--;
      notifyListeners();
    }
  }

  void funcOfAddCount() {
    bottomSheetModel!.count++;
    notifyListeners();
  }

  void funcAddProductCart({
    required BuildContext context,
    required String tag,
    required int cafeId,
    required ProductModel productModel,
    required int? cartModelId,
  }) async {
    safeBlock(() async {
      if (locator<LocalViewModel>().isGuest) {
        showSignInDialog(context);
      } else {
        await cafeRepository.addItemCart(tag: tag, cafeId: cafeId, cardItem: cartModelId, productModel: productModel);
        setSuccess(tag: tag);
        pop();
      }
    }, callFuncName: 'funcAddProduct');
  }

  void funcReload(String tag, CartModel cartModel) {
    getProductInfo(tag, cartModel, isload: false);
    notifyListeners();
  }

  void funcChangeCheckBox({required int i, required int index, bool? value}) {
    bottomSheetModel!.modifiers[i].items[index].mDefault = value ?? false;
    notifyListeners();
  }

  void funcChangeItemSingleMod({required int i, required Modifiers m, required int index}) {
    if (chossens[m.id] != null) {
      bottomSheetModel!.modifiers[i].items[chossens[m.id]!].mDefault = false;
    }
    chossens[m.id] = index;
    bottomSheetModel!.modifiers[i].items[index].mDefault = true;
    notifyListeners();
  }

  void funcSegmentControlChange(Object? value, CafeModel cafeModel) {
    selectTab = value as int;
    if (selectTab == 0) {
      curTime = 5;
    } else {
      curTime = cafeModel.deliveryMinTime!;
    }
    notifyListeners();
  }

  void funcTextButtons(int index, CafeModel cafeModel, BuildContext context) {
    if (index == 0) {
      curTime = selectTab == 0 ? 5 : cafeModel.deliveryMinTime!;
      notifyListeners();
    } else if (index == 1) {
      curTime = selectTab == 0 ? 15 : cafeModel.deliveryMinTime! + 10;
      notifyListeners();
    } else if (index == 2) {
      showMaterialModalBottomSheet(
          context: context,
          expand: false,
          builder: (context) {
            return CustomTimeBottomSheet(cafeModel: cafeModel);
          }).then((value) {
        if (value is DateTime) {
          custumTime = value;
          curTime = 3;
          notifyListeners();
        }
      });
      notifyListeners();
    }
  }

  void funcChangeItemSize({required int index}) {
    chossens[0] = index;
    bottomSheetModel!.sizes[index].mDefault = true;
    notifyListeners();
  }

  void funcScrollByCtg(AutoScrollController autoScrollController, int index) async {
    await autoScrollController.scrollToIndex(index,
        duration: const Duration(milliseconds: 800), preferPosition: AutoScrollPosition.begin);
    autoScrollController.highlight(index);
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
