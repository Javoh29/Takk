import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({required super.context, required this.userRepository, required this.localViewModel});

  final String tag = 'HomePageViewModel';
  final String tagUserData = 'loadUserData';
  late UserRepository userRepository;
  late LocalViewModel localViewModel;
  bool large = false;

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
  callBackError(String text) {
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
