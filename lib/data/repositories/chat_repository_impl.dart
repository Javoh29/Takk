import 'dart:convert';

import 'package:http/http.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/domain/repositories/chat_repository.dart';

import '../../config/constants/urls.dart';
import '../../core/di/app_locator.dart';
import '../models/cart_response.dart';

class ChatRepositoryImpl extends ChatRepository {
  ChatRepositoryImpl(this.client);

  final CustomClient client;
  List<LastMessage> _lastMessageList = [];
  CartResponse? _cartResponseOrder;
  MessageModel? _messageModel;
  int? _totalMessageCount = 0;

  @override
  Future<void> getMessageInfo(int id, bool isOrder) async {
    await getMessageCount(id);
    var response = await client.get(Url.getMessageInfo(id, _totalMessageCount));
    _lastMessageList = [];
    if (response.isSuccessful) {
      for (final item in jsonDecode(response.body)['results']) {
        var model = LastMessage.fromJson(item);
        if (isOrder && model.orderId != null) {
          _lastMessageList.add(model);
        } else if (model.orderId == null) {
          _lastMessageList.add(model);
        }
      }
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getMessageInfo');
    }
  }

  @override
  Future<void> getMessageCount(int id) async {
    var response = await client.get(Url.getMessageInfo(id, null));
    if (response.isSuccessful) {
      _totalMessageCount = jsonDecode(response.body)['count'];
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getMessageCount');
    }
  }

  @override
  Future<void> getOrderInfo(int id) async {
    var response = await client.get(Url.getOrderInfo(id));
    if (response.isSuccessful) {
      _cartResponseOrder = CartResponse.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getOrderInfo');
    }
  }

  @override
  Future<void> sendMessage(String value, int id, bool isFile) async {
    final Response response;

    var request = MultipartRequest("POST", Url.sendMessage);
    request.fields['company_id'] = id.toString();
    request.fields['text'] = value;
    request.headers['Authorization'] =
        'JWT ${locator<CustomClient>().tokenModel!.access}';
    request.headers['Content-Type'] = 'application/json';

    if (isFile) request.files.add(await MultipartFile.fromPath('files', value));
    var ans = await request.send();
    response = await Response.fromStream(ans);

    if (response.statusCode == 201) {
      var lastMessage = LastMessage.fromJson(jsonDecode(response.body));
      _lastMessageList.add(lastMessage);
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'sendMessage');
    }
  }

  @override
  Future<void> sendOrderMessage(String value, int id, bool isFile) async {
    final Response response;

    var request = MultipartRequest("POST", Url.sendMessageOrder);
    request.fields['order_id'] = id.toString();
    request.fields['text'] = value;
    request.headers['Authorization'] =
        'JWT ${locator<CustomClient>().tokenModel!.access}';
    // request.headers['Content-Type'] = 'application/json';

    if (isFile) request.files.add(await MultipartFile.fromPath('files', value));

    var ans = await request.send();
    response = await Response.fromStream(ans);

    if (response.statusCode == 201) {
      var lastMessage = LastMessage.fromJson(jsonDecode(response.body));
      _lastMessageList.add(lastMessage);
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'sendMessage');
    }
  }

  @override
  Future<void> getSelectedCompanyInfoForChat(int compId) async {
    var response = await client.get(Url.getCompanyInfoForChat(compId));
    if (response.isSuccessful) {
      _messageModel = MessageModel.fromJson(jsonDecode(response.body));
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
  MessageModel get messageModel => _messageModel!;

  @override
  set lastMessageList(List<LastMessage> lastMessageList) {
    _lastMessageList = lastMessageList;
  }
}
