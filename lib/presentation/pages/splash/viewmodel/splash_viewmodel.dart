import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/hive_box_names.dart';
import 'package:project_blueprint/core/di/app_locator.dart';
import 'package:project_blueprint/core/services/custom_client.dart';
import 'package:project_blueprint/data/models/token_model.dart';
import 'package:project_blueprint/presentation/routes/routes.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({required super.context});
  final String tag = 'SplashViewModel';

  Future<void> loadData() async {
    try {
      final tokenModel = await getBox<TokenModel>(BoxNames.tokenBox);
      locator<CustomClient>().tokenModel = tokenModel;
      navigateTo(Routes.authPage, waitTime: 2);
    } catch (e) {
      setError(VMException(e.toString(), callFuncName: 'loadData', tag: tag));
    }
  }

  @override
  callBackError(String text) {}
}
