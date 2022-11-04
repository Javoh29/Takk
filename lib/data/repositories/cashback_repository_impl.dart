import 'dart:collection';
import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/domain/repositories/cashback_repository.dart';

import '../../config/constants/urls.dart';

class CashbackRepositoryImpl extends CashbackRepository {
  CashbackRepositoryImpl(this.client);

  CustomClient client;
  Map<int, String> _cashbackStatistics = Map<int, String>();
  Map<int, String> _cashbackStaticList = Map<int, String>();

  @override
  Future<void> getCashbackStatistics() async {
    // TODO: page va page_size bor bu requestda
    var response = await client.get(Url.getCashbackStatistics);
    if (response.isSuccessful) {
      for (final item in jsonDecode(response.body)['results']) {
        _cashbackStatistics[item['year']] = item['total_cashback'];
      }
      if (_cashbackStatistics.length < 3) {
        var y = DateTime.now().year;
        if (_cashbackStatistics.length < 2) {
          _cashbackStatistics[y - 1] = "0";
          _cashbackStatistics[y - 2] = "0";
        } else {
          _cashbackStatistics[y - 2] = "0";
        }
        _cashbackStatistics = LinkedHashMap.fromEntries(
            _cashbackStatistics.entries.toList().reversed);
        await getCashbackList(y);
      }
    } else {
      throw VMException(response.body.parseError(),
          callFuncName: 'getCashbackStatistics', response: response);
    }
  }

  @override
  Future<void> getCashbackList(int period) async {
    var response = await client.get(Url.getCashbackList(period));
    if (response.isSuccessful) {
      for (final item in jsonDecode(response.body)['results']) {
        _cashbackStaticList[item['created_dt']] = item['cashback'];
      }
    } else {
      throw VMException(response.body.parseError(),
          callFuncName: 'getCashbackList', response: response);
    }
  }

  @override
  Map<int, String> get cashbackStaticList => _cashbackStaticList;

  @override
  Map<int, String> get cashbackStatistics => _cashbackStatistics;
}
