import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/product_model/product_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/ctg_model.dart';
import '../../../widgets/loading_dialog.dart';

class CafeViewModel extends BaseViewModel {
  CafeViewModel({required super.context});
  Future? dialog;

  Future<List<ProductModel>> getCafeProductList(String tag, int cafeId) async {
    List<ProductModel> listProducts = [];
    List<dynamic> cafeProducts = [];
    safeBlock(() async {
      var data =
          await locator<CafeRepository>().getCafeProductList(tag, cafeId);
      locator<LocalViewModel>().headCtgList = [
        for (final item in data['categories']) CtgModel.fromJson(item)
      ];
      for (final item in data['list']) {
        cafeProducts.add(item);
        if (item['type'] == 2)
          for (final e in item['products']) {
            listProducts.add(ProductModel.fromJson(e));
          }
      }
      locator<LocalViewModel>().cafeProducts.clear();
      locator<LocalViewModel>().cafeProducts=[...cafeProducts];
      locator<LocalViewModel>().listProducts.clear();
      locator<LocalViewModel>().listProducts = [...listProducts];
      setSuccess(tag: tag);
    }, callFuncName: 'getCafeProductList', tag: tag, inProgress: false);
    
    return listProducts;
  }

  Future<void> getCartList(String tag) async {
    safeBlock(() async {
      await locator<CafeRepository>().getCartList(tag);
      setSuccess(tag: tag);
    }, callFuncName: 'getCartList', inProgress: false);
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      dialog = showLoadingDialog(context!);
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
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
