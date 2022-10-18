import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';

import '../../config/constants/urls.dart';
import '../models/tariffs_model.dart';
import '../models/user_card_model.dart';

class TariffsRepositoryImpl extends TariffsRepository {
  TariffsRepositoryImpl(this.client);

  final CustomClient client;

  @override
  Future<void> getTariffs() async {
    var response = await client.get(Url.getTariffs);
    if (response.isSuccessful) {
      locator<LocalViewModel>().tariffsList = [
        for (final item in jsonDecode(response.body)) TariffModel.fromJson(item)
      ];
      await getUserCards();
      // setState(tag, 'success');
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'getTariffs', response: response);
  }

  @override
  Future<void> getUserCards() async {
    var response = await client.get(Url.getUserCards);
    if (response.isSuccessful) {
      locator<LocalViewModel>().cardList = [
        for (final item in jsonDecode(response.body)['results'])
          UserCardModel.fromJson(item)
      ];
      // setState(tag, 'success');
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'getUserCards', response: response);
  }

  @override
  Future<String?> getClientSecretKey(String name) async {
    var response = await client.post(Url.getClientSecret, body: {'name': name});
    if (response.isSuccessful) {
      String key = jsonDecode(response.body)['client_secret'];
      // setState(tag, 'success');
      return key;
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'getClientSecretKey', response: response);
  }

  @override
  Future<String?> setBalancePayment(
      String tag, int tId, int type, int cId) async {
    var response = await client.post(Url.setBalancePayment, body: {
      'tariff_id': tId.toString(),
      'payment_type': type.toString(),
      'card_id': cId.toString()
    });
    if (response.isSuccessful) {
      String b = jsonDecode(response.body)['payment_status'];
      // setState(tag, 'success');
      return b;
    }
    throw VMException(response.body.parseError(),
        callFuncName: 'setBalancePayment', response: response);
  }
}
