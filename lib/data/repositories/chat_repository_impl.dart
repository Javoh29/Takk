import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/chat_repository.dart';

import '../../config/constants/urls.dart';
import '../models/cart_response.dart';

class ChatRepositoryImpl extends ChatRepository {
  late final CustomClient client;
  TokenModel? token;

  ChatRepositoryImpl(Object object);

  @override
  Future<List<LastMessage>?> getMessageInfo(String tag, int id) async {
    var response = await client.get(Url.getMessageInfo(id), headers: {"Authorization": 'JWT ${token!.access}'});
    if (response.isSuccessful) {
      locator<LocalViewModel>().lastMessageList = [
        for (final item in jsonDecode(response.body)['results']) LastMessage.fromJson(item)
      ];
      return locator<LocalViewModel>().lastMessageList;
    }
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getMessageInfo');
  }

  @override
  Future<CartResponse?> getOrderInfo(String tag, int id) async {
    var response = await get(Url.getOrderInfo(id), headers: {'Authorization': 'JWT ${token!.access}'});
    if (response.isSuccessful) {
      locator<LocalViewModel>().cartResponseOrder = CartResponse.fromJson(
        jsonDecode(response.body),
      );
      return locator<LocalViewModel>().cartResponseOrder;
    }
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getOrderInfo');
  }
}
