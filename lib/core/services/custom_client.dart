import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/core/di/app_locator.dart';
import 'package:project_blueprint/data/models/token_model.dart';
import 'package:project_blueprint/data/viewmodel/local_viewmodel.dart';

class CustomClient extends JClient {
  CustomClient(this.tokenModel);

  TokenModel? tokenModel;

  @override
  Map<String, String>? getGlobalHeaders() {
    return {'Authorization': 'JWT ${tokenModel?.access}'};
  }

  @override
  int get unauthorized => 401;

  @override
  Future updateToken() async {
    tokenModel = await locator<LocalViewModel>().updateToken();
  }
}
