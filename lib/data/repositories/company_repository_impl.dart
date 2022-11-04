import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/constants.dart';
import 'package:takk/core/domain/date_time_type.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/company_model.dart';
import 'package:takk/domain/repositories/company_repository.dart';

import '../../config/constants/hive_box_names.dart';
import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';
import '../../core/domain/entties/date_time_enum.dart';
import '../viewmodel/local_viewmodel.dart';

class CompanyRepositoryImpl extends CompanyRepository {
  CompanyRepositoryImpl(this.client);

  final CustomClient client;
  List<CompanyModel> _companiesList = [];
  int _pageCount = 0;

  @override
  Future<void> getCompanyInfo() async {
    LocalViewModel localViewModel = locator.get();
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
    await getCompanyCount();
    var response = await client.get(Url.getCompList(_pageCount));
    if (response.isSuccessful) {
      _companiesList = [for (final item in jsonDecode(response.body)['results']) CompanyModel.fromJson(item)];
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'getCompList', response: response);
    }
  }

  @override
  Future<void> getCompanyCount() async {
    var response = await client.get(Url.getCompList(null));
    if (response.isSuccessful) {
      _pageCount = jsonDecode(response.body)['count'];
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'getCompList', response: response);
    }
  }

  @override
  Future<void> givePoints(int points, String phone, int id) async {
    var map = jsonEncode({'points': points, 'phone': phone, 'company': id});
    var response = await client.post(Url.givePoints, body: map, headers: headerContent);
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(), callFuncName: 'givePoints', response: response);
    }
  }

  @override
  List<CompanyModel> get companiesList => _companiesList;
}
