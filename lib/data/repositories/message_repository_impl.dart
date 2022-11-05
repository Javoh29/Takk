import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/domain/repositories/chat_repository.dart';
import 'package:takk/domain/repositories/message_repository.dart';

import '../../config/constants/urls.dart';
import '../models/message_model/message_model.dart';

class MessageRepositoryImpl extends MessageRepository {
  MessageRepositoryImpl(this.client);

  final CustomClient client;
  List<MessageModel> _messagesList = [];
  int _totalCount = 0;

  @override
  Future<void> getMessage() async {
    _messagesList.clear();
    await getPageCount();
    var response = await client.get(Url.getMessages(_totalCount));
    if (response.isSuccessful) {
      for (final item in jsonDecode(response.body)['results']) {
        var model = MessageModel.fromJson(item);
        if (model.lastMessage != null) {
          if (model.lastMessage!.orderId != null) {
            await locator<ChatRepository>()
                .getMessageInfo(model.id!, false);
            model.lastMessage!.text = locator<ChatRepository>().lastMessageList.last.text;
            model.lastMessage!.files = null;
            _messagesList.add(model);
          } else {
            _messagesList.add(model);
          }
        }
      }
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getMessage');
    }
  }

  Future<void> getPageCount() async {
    var response = await client.get(Url.getMessages(null));
    if (response.isSuccessful) {
      _totalCount = jsonDecode(response.body)['count'];
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getMessage');
    }
  }

  @override
  List<MessageModel> get messagesList => _messagesList;
}
