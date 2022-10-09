import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/presentation/routes/routes.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({required super.context});
  final String tag = 'SplashViewModel';

  Future<void> loadData() async {
    safeBlock(() async {
      final tokenModel = await getBox<TokenModel>(BoxNames.tokenBox);
      locator<CustomClient>().tokenModel = tokenModel;
      await locator<CafeRepository>().getCafeList(isLoad: true);
      navigateTo(tokenModel != null ? Routes.homePage : Routes.authPage, waitTime: 2);
    }, callFuncName: 'loadData', inProgress: false);
  }
}
