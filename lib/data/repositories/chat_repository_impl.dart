import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/domain/repositories/chat_repository.dart';

import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';
import '../models/cart_response.dart';

class ChatRepositoryImpl extends ChatRepository {
  ChatRepositoryImpl(this.client);

  final CustomClient client;
  List<LastMessage> _lastMessageList = [];
  CartResponse? _cartResponseOrder;

  @override
  Future<void> getMessageInfo(int id) async {
    var response = await client.get(Url.getMessageInfo(id));
    if (response.isSuccessful) {
      _lastMessageList = [
        for (final item in jsonDecode(response.body)['results'])
          LastMessage.fromJson(item)
      ];
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getMessageInfo');
    }
  }

  @override
  Future<void> getOrderInfo(int id) async {
    var response = await client.get(Url.getOrderInfo(id));
    if (response.isSuccessful) {
      _cartResponseOrder = CartResponse.fromJson(
        jsonDecode(response.body),
      );
      // return _cartResponseOrder;
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getOrderInfo');
    }
  }

  @override
  Future<int?> createChat(bool isOrder, int id) async {
    var response = await client.post(
      Url.sendMessage,
      body: jsonEncode({
        'company_id': id,
        'chat_type': isOrder ? 'order' : 'company',
        if (isOrder) 'order': id else 'company': id
      }),
      // headers: {
      //   'Content-Type': 'application/json'
      // }
    );
    if (response.isSuccessful) {
      int chatId = jsonDecode(response.body)['id'];
      return chatId;
    }
    throw VMException(response.body.parseError(),
        response: response, callFuncName: 'createChat');
  }

  @override
  Future<void> sendMessage(String value, int companyId, bool isFile) async {
    final Response response;
    // if (isFile) {
    var request = MultipartRequest("POST", Url.sendMessage);
    request.fields['company_id'] = companyId.toString();
    request.fields['text'] = value;
    request.headers['Authorization'] =
        'JWT ${locator<CustomClient>().tokenModel!.access}';
    if (isFile) request.files.add(await MultipartFile.fromPath('files', value));
    var ans = await request.send();
    response = await Response.fromStream(ans);
    // } else {
    //   response = await client.post(
    //     Url.sendMessage,
    //     body: jsonEncode({
    //       'company_id': chatId,
    //       'text': value,
    //       'files': null,
    //     }),
    //     // headers: {
    //     // 'Authorization': 'JWT ${token!.access}',
    //     // 'Content-Type': 'application/json'
    //     // }
    //   );
    // }
    if (response.statusCode == 201) {
      var lastMessage = LastMessage.fromJson(jsonDecode(response.body));
      _lastMessageList.add(lastMessage);
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'sendMessage');
    }
  }

  @override
  Future<int?> getSelectedCompanyInfoForChat(int id) async {
    var response = await client.get(Url.getCompanyInfoForChat(id));
    if (response.isSuccessful) {
      return jsonDecode(response.body)['id'];
    } else {
      throw VMException(response.body.parseError(),
          callFuncName: 'getSelectedCompanyInfoForChat', response: response);
    }
  }

  @override
  List<LastMessage> get lastMessageList => _lastMessageList;

  @override
  CartResponse get cartResponseOrder => _cartResponseOrder!;

  @override
  set lastMessageList(List<LastMessage> lastMessageList) {
    _lastMessageList = lastMessageList;
  }
}
