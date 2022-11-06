import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';
import 'package:takk/domain/repositories/company_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/services/custom_client.dart';
import '../../../../data/models/country_model.dart';
import '../../../../domain/repositories/cafe_repository.dart';
import '../../../widgets/loading_dialog.dart';

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
  Future? dialog;

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
    safeBlock(() async {
      String data = await DefaultAssetBundle.of(context!).loadString("assets/data/countries.json");
      var j = jsonDecode(data);
      listCountryAll = [for (final item in j) CountryModel.fromJson(item)];
      listCountrySort.addAll(listCountryAll);
    }, callFuncName: 'loadLocalData', inProgress: false);
  }

  Future<void> getCompanyInfo() async {
    safeBlock(() async {
      await locator<CompanyRepository>().getCompanyInfo();
      navigateTo(Routes.homePage, isRemoveStack: true);
    }, callFuncName: 'getCompanyInfo');
  }

  Future<void> setAuth({String? code}) async {
    if (phoneNumber.isNotEmpty) {
      safeBlock(() async {
        final tokenModel = await authRepository.setAuth('${selectCountry.dialCode}$phoneNumber', code: code);
        locator<CustomClient>().tokenModel = tokenModel;
        if (code != null) {
          // TODO: fixing
          final currentPosition = await locator<UserRepository>().getLocation();
          String? query;
          if (currentPosition != null) {
            query = '?lat=${currentPosition.latitude}&long=${currentPosition.longitude}';
          }
          final userModel = await locator<UserRepository>().getUserData();
          await locator<CafeRepository>().getCafeList(query: query, isLoad: true);
          if (userModel?.userType == 2) {
            await locator<CafeRepository>().getEmployeesCafeList(isLoad: true);
          }
          // TODO: fixing
          await locator<UserRepository>().setDeviceInfo();
          await locator<CompanyRepository>().getCompanyInfo();
          await saveBox<TokenModel>(BoxNames.tokenBox, tokenModel);
          if (tokenModel.register == true) {
            navigateTo(Routes.homePage, isRemoveStack: true);
          } else {
            navigateTo(Routes.createUserPage);
          }
        } else {
          navigateTo(Routes.checkCodePage, arg: {'phone': phoneNumber, 'country': selectCountry});
        }
      }, callFuncName: 'setPhoneNumber');
    } else {
      showTopSnackBar(
        context!,
        const CustomSnackBar.info(
          message: 'Please enter your phone number!',
          backgroundColor: AppColors.warningColor,
        ),
      );
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
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
