import 'package:jbaza/jbaza.dart';

import '../../../../data/models/country_model.dart';

class AuthViewModel extends BaseViewModel {
  AuthViewModel({required super.context});

  CountryModel selectCountry =
      CountryModel(name: 'United States', flag: '🇺🇸', code: 'US', dialCode: 1, maxLength: 10);
  List<CountryModel> listCountryAll = [];
  List<CountryModel> listCountrySort = [];
  bool isOpenDrop = false;
  bool isValidate = false;
  String phoneNumber = '';

  @override
  callBackError(String text) {}
}
