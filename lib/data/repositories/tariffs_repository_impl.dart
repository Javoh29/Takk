import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';

import '../../config/constants/urls.dart';
import '../models/tariffs_model.dart';
import '../models/user_card_model.dart';

class TariffsRepositoryImpl extends TariffsRepository {
  TariffsRepositoryImpl(this.client);

  final CustomClient client;
  List<TariffModel> _tariffsList = [];
  List<UserCardModel> _cardList = [];

  @override
  Future<void> getTariffs() async {
    var response = await client.get(Url.getTariffs);
    if (response.isSuccessful) {
      _tariffsList = [for (final item in jsonDecode(response.body)) TariffModel.fromJson(item)];
      await getUserCards();
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'getTariffs', response: response);
    }
  }

  @override
  Future<void> getUserCards() async {
    var response = await client.get(Url.getUserCards);
    if (response.isSuccessful) {
      _cardList = [for (final item in jsonDecode(response.body)['results']) UserCardModel.fromJson(item)];
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'getUserCards', response: response);
    }
  }

  @override
  Future<String?> getClientSecretKey(String name) async {
    var response = await client.post(Url.getClientSecret, body: {'name': name});
    if (response.isSuccessful) {
      String key = jsonDecode(response.body)['client_secret'];
      return key;
    }
    throw VMException(response.body.parseError(), callFuncName: 'getClientSecretKey', response: response);
  }

  @override
  Future<String?> setBalancePayment(String tag, int tId, int type, int cId) async {
    var response = await client.post(Url.setBalancePayment,
        body: {'tariff_id': tId.toString(), 'payment_type': type.toString(), 'card_id': cId.toString()});
    if (response.isSuccessful) {
      String b = jsonDecode(response.body)['payment_status'];
      return b;
    }
    throw VMException(response.body.parseError(), callFuncName: 'setBalancePayment', response: response);
  }

  @override
  List<TariffModel> get tariffsList => _tariffsList;

  @override
  List<UserCardModel> get cardList => _cardList;
}
