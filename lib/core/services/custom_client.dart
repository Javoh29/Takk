import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';

class CustomClient extends JClient {
  CustomClient(this.tokenModel);

  TokenModel? tokenModel;

  @override
  Map<String, String>? getGlobalHeaders() {
    if (tokenModel != null && tokenModel?.access != null) {
      return {'Authorization': 'JWT ${tokenModel?.access}'};
    }
    return null;
  }

  @override
  int get unauthorized => 401;

  @override
  Future updateToken() async {
    tokenModel = await locator<LocalViewModel>().updateToken();
  }
}
