import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../domain/repositories/company_repository.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({
    required super.context,
  });

  final String tag = 'SplashViewModel';

  Future<void> loadData() async {
    safeBlock(() async {
      final tokenModel = await getBox<TokenModel>(BoxNames.tokenBox);
      locator<CustomClient>().tokenModel = tokenModel;
      if (tokenModel != null) {
        getUserDate();
      } else {
        navigateTo(tokenModel != null ? Routes.homePage : Routes.authPage,
            waitTime: 2);
      }
    }, callFuncName: 'loadData', inProgress: false);
  }

  Future<void> getUserDate() async {
    safeBlock(
      () async {
        final userModel = await locator<UserRepository>().getUserData();
        if (userModel != null) {
          getCafesData();
        } else {
          navigateTo(Routes.authPage, isRemoveStack: true);
        }
      },
      callFuncName: "getUserDate",
    );
  }

  Future<void> getCafesData() async {
    safeBlock(() async {
      final currentPosition = await locator<UserRepository>().getLocation();
      String? query;
      if (currentPosition != null) {
        query =
            '?lat=${currentPosition.latitude}&long=${currentPosition.longitude}';
      }
      final cafeList = await locator<CafeRepository>()
          .getCafeList(query: query, isLoad: true);
      if (locator<UserRepository>().userModel?.userType == 2) {
        await locator<CafeRepository>().getEmployeesCafeList(isLoad: true);
      }
      if (cafeList.isNotEmpty) {
        await locator<CompanyRepository>().getCompanyInfo();
        navigateTo(Routes.homePage, isRemoveStack: true);
      }
    }, callFuncName: "getCafesData");
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
