import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/hive_box_names.dart';
import 'package:project_blueprint/core/di/app_locator.dart';
import 'package:project_blueprint/core/domain/date_time_type.dart';
import 'package:project_blueprint/core/domain/entties/date_time_enum.dart';
import 'package:project_blueprint/data/models/comp_model.dart';
import 'package:project_blueprint/data/viewmodel/local_viewmodel.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';

import '../../../../data/models/country_model.dart';

class AuthViewModel extends BaseViewModel {
  AuthViewModel({required super.context, required this.authRepository});
  final AuthRepository authRepository;
  final LocalViewModel localViewModel = locator.get();

  CountryModel selectCountry =
      CountryModel(name: 'United States', flag: '🇺🇸', code: 'US', dialCode: 1, maxLength: 10);
  List<CountryModel> listCountryAll = [];
  List<CountryModel> listCountrySort = [];
  bool isOpenDrop = false;
  bool isValidate = false;
  String phoneNumber = '';

  Future<void> loadLocalData() async {
    try {
      String data = await DefaultAssetBundle.of(context!).loadString("assets/data/countries.json");
      var j = jsonDecode(data);
      listCountryAll = [for (final item in j) CountryModel.fromJson(item)];
      listCountrySort.addAll(listCountryAll);
    } catch (e) {
      setError(VMException(e.toString(), callFuncName: 'loadLocalData'));
    }
  }

  Future<void> getCompanyInfo() async {
    try {
      final model = await authRepository.getCompanyModel();
      final typeDay = DateTime.now().getDateType();
      localViewModel.dateTimeEnum = typeDay;
      var dw = DefaultCacheManager();
      final boxModel = await getBox<CompanyModel>(BoxNames.companyBox);
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
      await saveBox<CompanyModel>(BoxNames.companyBox, model);
      setSuccess();
    } on VMException catch (vm) {
      setError(vm);
    } catch (e) {
      setError(VMException(
        e.toString(),
        callFuncName: 'getCompanyInfo',
      ));
    }
  }

  @override
  callBackError(String text) {}
}
