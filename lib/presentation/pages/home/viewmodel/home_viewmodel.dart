import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../widgets/loading_dialog.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required super.context, required this.userRepository, required this.localViewModel});

  final String tag = 'HomePageViewModel';
  final String tagUserData = 'loadUserData';
  late UserRepository userRepository;
  late LocalViewModel localViewModel;
  bool large = false;

  Future? dialog;

  Future<void> changeFavorite(CafeModel cafeModel) async {
    safeBlock(() async {
      await locator<CafeRepository>().changeFavorite(cafeModel);
      cafeModel.isFavorite = !cafeModel.isFavorite!;
      setSuccess(tag: cafeModel.id.toString());
    }, callFuncName: 'changeFavorite', tag: cafeModel.id.toString());
  }

  Future<void> loadUserData() async {
    safeBlock(() async {
      await userRepository.getUserData();
      setSuccess(tag: tagUserData);
    }, callFuncName: 'loadUserData', tag: tagUserData);
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (tag != tagUserData) {
      if (dialog == null && isBusy(tag: tag)) {
        Future.delayed(Duration.zero, () {
          dialog = showLoadingDialog(context!);
        });
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
