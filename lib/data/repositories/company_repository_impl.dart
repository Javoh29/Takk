import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/core/domain/date_time_type.dart';
import 'package:project_blueprint/core/domain/http_is_success.dart';
import 'package:project_blueprint/core/services/custom_client.dart';
import 'package:project_blueprint/data/models/comp_model.dart';
import 'package:project_blueprint/domain/repositories/company_repository.dart';

import '../../config/constants/hive_box_names.dart';
import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';
import '../../core/domain/entties/date_time_enum.dart';
import '../viewmodel/local_viewmodel.dart';

class CompanyRepositoryImpl extends CompanyRepository {
  const CompanyRepositoryImpl(this.client);
  final CustomClient client;
  @override
  Future<void> getCompanyInfo() async {
    final LocalViewModel localViewModel = locator.get();
    final model = await getCompanyModel();
    final typeDay = DateTime.now().getDateType();
    localViewModel.dateTimeEnum = typeDay;
    var dw = DefaultCacheManager();
    final boxModel =
        await localViewModel.getBox<CompanyModel>(BoxNames.companyBox);
    if (boxModel?.id == model.id) {
      var fl = await dw.getFileFromCache('bgImg$typeDay');
      if (fl != null) localViewModel.bgImage = fl.file;
    } else {
      await dw.downloadFile(model.loadingAppImage, key: 'loadImg');
      var fl1 = await dw.downloadFile(model.appImageMorning, key: 'bgImg1');
      var fl2 = await dw.downloadFile(model.appImageDay, key: 'bgImg2');
      var fl3 = await dw.downloadFile(model.appImageEvening, key: 'bgImg3');
      localViewModel.bgImage = typeDay == DateTimeEnum.morning
          ? fl1.file
          : typeDay == DateTimeEnum.afternoon
              ? fl2.file
              : fl3.file;
    }
    await localViewModel.saveBox<CompanyModel>(BoxNames.companyBox, model);
  }

  @override
  Future<CompanyModel> getCompanyModel() async {
    var response = await client.get(Url.getCompInfo);
    if (response.isSuccessful)
      return CompanyModel.fromJson(jsonDecode(response.body));
    throw VMException(response.body,
        callFuncName: 'getCompanyModel', response: response);
  }
}
