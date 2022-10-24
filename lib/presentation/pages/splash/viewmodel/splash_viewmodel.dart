import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/data/models/user_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import 'package:takk/presentation/routes/routes.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({
    required super.context,
  });

  final String tag = 'SplashViewModel';

  Future<void> loadData() async {
    safeBlock(() async {
      final tokenModel = await getBox<TokenModel>(BoxNames.tokenBox);
      locator<CustomClient>().tokenModel = tokenModel;
      await locator<CafeRepository>().getCafeList(isLoad: true);
      await locator<FavoriteRepository>().getFavList(tag);
      if(tokenModel != null) getUserDate();
      navigateTo(tokenModel != null ? Routes.homePage : Routes.authPage,
          waitTime: 2);
      navigateTo(tokenModel != null ? Routes.homePage : Routes.authPage, waitTime: 2);
    }, callFuncName: 'loadData', inProgress: false);
  }

  Future<void> getUserDate() async {
    safeBlock(
      () async {
        final userModel = await locator<UserRepository>().getUserData();
        if (userModel != null) {
          locator<LocalViewModel>().userModel = userModel;
          //TODO: get cafe data
        } else {
          navigateTo(Routes.authPage, isRemoveStack: true);
        }
      },
      callFuncName: "getUserDate",
    );
  }

  Future<void> getCafesData() async {
    safeBlock(() async {
      final userModel = await locator<UserRepository>().getUserData();
      final cafeList =
          await locator<CafeRepository>().getCafeList(query: '', isLoad: true);
      if (userModel?.userType == 2) {
        await locator<CafeRepository>().getEmployeesCafeList(isLoad: true);
      }
      if (cafeList.isNotEmpty) {
        navigateTo(Routes.homePage, isRemoveStack: true);
      }
    }, callFuncName: "getCafesData");
  }
}
