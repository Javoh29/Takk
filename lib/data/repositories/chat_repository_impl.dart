import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/domain/repositories/chat_repository.dart';

import '../../config/constants/urls.dart';
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
    var response = await client.post(Url.createChat,
        body: jsonEncode({
          'chat_type': isOrder ? 'order' : 'company',
          if (isOrder) 'order': id else 'company': id
        }),
        headers: {
          'Content-Type': 'application/json'
        });
    if (response.isSuccessful) {
      int chatId = jsonDecode(response.body)['id'];
      return chatId;
    }
    throw VMException(response.body.parseError(),
        response: response, callFuncName: 'createChat');
  }

  @override
  Future<void> sendMessage(String value, int chatId, bool isFile) async {
    final Response response;
    if (isFile) {
      var request = MultipartRequest("POST", Url.sendMessage);
      request.fields['item_type'] = 'image';
      request.fields['chat'] = chatId.toString();
      // request.headers['Authorization'] = 'JWT ${token!.access}';
      request.files.add(await MultipartFile.fromPath('files', value));
    var ans = await request.send();
    response = await Response.fromStream(ans);
    } else {
    response = await post(Url.sendMessage,
    body: jsonEncode(
    {'item_type': 'message', 'text': value, 'chat': chatId}),
    // headers: {
    // 'Authorization': 'JWT ${token!.access}',
    // 'Content-Type': 'application/json'
    // }
    );
    }
    if (response.statusCode == 201) {
    var lastMessage = LastMessage.fromJson(jsonDecode(response.body));
    _lastMessageList.add(lastMessage);
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
