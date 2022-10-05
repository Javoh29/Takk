import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/core/di/app_locator.dart';
import 'package:project_blueprint/domain/repositories/auth_repository.dart';
import 'package:project_blueprint/domain/repositories/company_repository.dart';

import '../../../../data/models/country_model.dart';

class AuthViewModel extends BaseViewModel {
  AuthViewModel({required super.context, required this.authRepository});
  final AuthRepository authRepository;
  final String tag = 'AuthViewModel';

  CountryModel selectCountry =
      CountryModel(name: 'United States', flag: '🇺🇸', code: 'US', dialCode: 1, maxLength: 10);
  List<CountryModel> listCountryAll = [];
  List<CountryModel> listCountrySort = [];
  bool _isOpenDrop = false;
  bool _isValidate = false;
  String phoneNumber = '';

  set isOpenDrop(bool value) {
    _isOpenDrop = value;
    notifyListeners();
  }

  set isValidate(bool value) {
    _isValidate = value;
    notifyListeners();
  }

  bool get isValidate => _isValidate;
  bool get isOpenDrop => _isOpenDrop;

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
      await locator<CompanyRepository>().getCompanyInfo();
      setSuccess();
    } on VMException catch (vm) {
      setError(vm.copyWith(tag: tag));
    } catch (e) {
      setError(VMException(
        e.toString(),
        callFuncName: 'getCompanyInfo',
      ));
    }
  }

  void setCountryModel(int index) {
    _isOpenDrop = false;
    selectCountry = listCountrySort[index];
    listCountrySort.clear();
    listCountrySort.addAll(listCountryAll);
    notifyListeners();
  }

  void searchCountry(String text) {
    listCountrySort.clear();
    if (text.isNotEmpty) {
      for (var element in listCountryAll) {
        if (element.code.toLowerCase() == text || element.name.toLowerCase().startsWith(text)) {
          listCountrySort.add(element);
        }
      }
    } else {
      listCountrySort.addAll(listCountryAll);
    }
    notifyListeners();
  }

  @override
  callBackError(String text) {}
}
