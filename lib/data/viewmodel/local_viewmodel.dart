import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/entties/date_time_enum.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';

import '../models/cafe_model/ctg_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  File? bgImage;
  Future? dialog;
  bool isCashier = false;
  bool isGuest = false;
  DateTimeEnum typeDay = DateTimeEnum.morning;

  ValueNotifier<bool> notifier = ValueNotifier(false);
  ValueNotifier<List<int>> alarm = ValueNotifier([]);

  List<CtgModel> headCtgList = [];

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
}
