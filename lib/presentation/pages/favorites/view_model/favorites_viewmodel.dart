import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../widgets/loading_dialog.dart';

class FavoritesViewModel extends BaseViewModel {
  FavoritesViewModel({required super.context, required this.favoriteRepo});
  FavoriteRepository favoriteRepo;

  Future? dialog;
  Future<void> getFavList(String tag) async {
    safeBlock(
      () async {
        await favoriteRepo.getFavList(tag);
        setSuccess(tag: tag);
      },
      callFuncName: 'getFavList',
      tag: tag,
    );
  }

  Future<void> clearCart(String tag) async {
    safeBlock(
      () async {
        await favoriteRepo.clearCart(tag);
        setSuccess(tag: tag);
      },
      callFuncName: 'clearCart',
      tag: tag,
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
