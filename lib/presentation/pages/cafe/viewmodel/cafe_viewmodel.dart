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
import '../../../routes/routes.dart';
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
  Map<int, int> chossens = {};
  int selectTab = 0;
  int selectTimeIndex = 0;
  Map<int, int> mapIndex = {};

  Future<List<ProductModel>> getCafeProductList(String tag, int cafeId) async {
    safeBlock(() async {
      var data = await cafeRepository.getCafeProductList(cafeId);
      locator<LocalViewModel>().headCtgList = [
        for (final item in data['categories']) CtgModel.fromJson(item)
      ];
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
      // TODO: cart yuklanyapti lekin ui da yangilanmayapti!!!
      await getCartList(tag);
      setSuccess(tag: tag);
    }, callFuncName: 'getCafeProductList', tag: tag);

    return listProducts;
  }

  Future<void> getCartList(String tag) async {
    safeBlock(() async {
      await locator<CartRepository>().getCartList();
    }, callFuncName: 'getCartList', inProgress: false, isChange: false);
  }

  void basketFunction(
      String tag, BuildContext context, CafeModel cafeModel) async {
    if (locator<LocalViewModel>().isGuest) {
      showSignInDialog(context);
    } else {
      safeBlock(() async {
        double t = 0;
        if (custumTime != null) {
          t = custumTime!.millisecondsSinceEpoch / 1000;
        } else {
          t = DateTime.now()
                  .add(Duration(minutes: curTime))
                  .millisecondsSinceEpoch /
              1000;
        }
        bool request =
            await cafeRepository.checkTimestamp(cafeModel.id!, t.toInt());
        if (request) {
          navigateTo(Routes.cartPage, arg: {
            'curTime': curTime,
            'custumTime': custumTime,
            'isPickUp': selectTab == 0
          }).then((value) => setSuccess(tag: tag));
        } else {
          callBackError('Please choose another pickup time!');
          setSuccess(tag: tag);
        }
      }, callFuncName: 'basketFunction', inProgress: false);
    }
  }

  void filter(String text) {
    isSearch = text.isNotEmpty;
    listSearchProducts.clear();
    if (text.isNotEmpty) {
      for (var e in listProducts) {
        if (e.name!.toLowerCase().contains(text.toLowerCase())) {
          listSearchProducts.add(e);
        }
      }
    }
    listSearchProducts;
    notifyListeners();
  }

  void cartListFunction(
      {required String tag,
      required BuildContext context,
      required CafeModel cafeModel}) {
    safeBlock(() async {
      if (locator<LocalViewModel>().isGuest) {
         showSignInDialog(context);
      } else {
         Future.delayed(Duration.zero, () async {
          double t = 0;
          if (custumTime != null) {
            t = custumTime!.millisecondsSinceEpoch / 1000;
          } else {
            t = DateTime.now()
                    .add(Duration(minutes: curTime))
                    .millisecondsSinceEpoch /
                1000;
          }
          bool isAvailable =
              await cafeRepository.checkTimestamp(cafeModel.id!, t.toInt());

          if (isAvailable) {
            navigateTo(Routes.cartPage, arg: {
              'curTime': curTime,
              'custumTime': custumTime,
              'isPickUp': selectTab == 0
            }).then((value) => pop());
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
      changeStatusProduct(productModel.id, cafeModel.id!, !available);
    } else if (isFavorite || available) {
      showCupertinoModalBottomSheet(
        context: context,
        expand: true,
        builder: (context) => AddGdsSheet(
          cafeId: cafeModel.id!,
          productModel: productModel,
        ),
      ).then((value) {
        if (isFavorite && value is bool) {
          pop(result: true);
        }
      });
    }
  }

  void changeStatusProduct(int id, int cafeId, bool isAvailable) {
    safeBlock(() async {
      await cafeRepository.changeStatusProduct(id, cafeId, isAvailable);
      for (var data in cafeProducts) {
        if (data['type'] == 2) {
          for (final item in data['products']) {
            if (item['id'] == id) {
              item['available'] = isAvailable;
            }
          }
        }
      }
      setSuccess();
    }, callFuncName: 'changeStatusProduct');
  }

  void getProductInfo(String tag, CartModel cartModel, {bool? isload}) {
    safeBlock(() async {
      setBusy(true, tag: tag, isCallBack: false);
      bottomSheetModel = await cafeRepository.getProductInfo(cartModel);
      setSuccess(tag: tag);
    }, callFuncName: 'getProductInfo', inProgress: isload ?? false, tag: tag);
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
    if (locator<LocalViewModel>().isGuest) {
      showSignInDialog(context);
    } else {
      safeBlock(() async {
        await cafeRepository.addItemCart(
            cafeId: cafeId, cardItem: cartModelId, productModel: productModel);
        setSuccess(tag: tag);
        pop(result: true);
      }, callFuncName: 'funcAddProduct');
    }
  }

  void funcReload(String tag, CartModel cartModel) {
    getProductInfo(tag, cartModel, isload: false);
  }

  void funcChangeCheckBox({required int i, required int index, bool? value}) {
    bottomSheetModel!.modifiers[i].items[index].mDefault = value ?? false;
    notifyListeners();
  }

  void funcChangeItemSingleMod(
      {required int i, required Modifiers m, required int index}) {
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
    selectTimeIndex = index;
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

  void funcScrollByCtg(
      AutoScrollController autoScrollController, int index) async {
    await autoScrollController.scrollToIndex(index,
        duration: const Duration(milliseconds: 800),
        preferPosition: AutoScrollPosition.begin);
    autoScrollController.highlight(index);
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
