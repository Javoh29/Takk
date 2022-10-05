import 'package:flutter_cache_manager/file.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/hive_box_names.dart';
import 'package:project_blueprint/core/di/app_locator.dart';
import 'package:project_blueprint/core/domain/entties/date_time_enum.dart';
import 'package:project_blueprint/data/models/token_model.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  DateTimeEnum dateTimeEnum = DateTimeEnum.morning;
  File? bgImage;

  Future<TokenModel> updateToken() async {
    final tokenModel = await locator<AuthRepository>().updateToken();
    await saveBox<TokenModel>(BoxNames.tokenBox, tokenModel);
    return tokenModel;
  }

  @override
  void dispose() async {
    super.dispose();
    await closeBox(BoxNames.tokenBox);
  }

  @override
  callBackError(String text) {}
}
