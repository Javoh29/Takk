import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/date_time_type.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/comp_model.dart';
import 'package:takk/domain/repositories/company_repository.dart';

import '../../config/constants/hive_box_names.dart';
import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';
import '../../core/domain/entties/date_time_enum.dart';
import '../models/companies_model.dart';
import '../viewmodel/local_viewmodel.dart';

class CompanyRepositoryImpl extends CompanyRepository {
  const CompanyRepositoryImpl(this.client);

  final CustomClient client;

  @override
  Future<void> getCompanyInfo() async {
    final LocalViewModel localViewModel = locator.get();
    final model = await getCompanyModel();
    final typeDay = DateTime.now().getDateType();
    localViewModel.typeDay = typeDay;
    var dw = DefaultCacheManager();
    final boxModel = await localViewModel.getBox<CompanyModel>(BoxNames.companyBox);
    if (boxModel?.id == model.id) {
      var fl = await dw.getFileFromCache(
          'bgImg${typeDay == DateTimeEnum.morning ? '1' : typeDay == DateTimeEnum.afternoon ? '2' : '3'}');
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
    if (response.isSuccessful) {
      return CompanyModel.fromJson(jsonDecode(response.body));
    }
    throw VMException(response.body.parseError(), callFuncName: 'getCompanyModel', response: response);
  }

  @override
  Future<void> getCompList() async {
    var response = await client.get(Url.getCompList);
    if (response.isSuccessful) {
      locator<LocalViewModel>().companiesList = [
        for (final item in jsonDecode(response.body)['results']) CompaniesModel.fromJson(item)
      ];
    }
    throw VMException(response.body.parseError(), callFuncName: 'getCompList', response: response);
  }
}
