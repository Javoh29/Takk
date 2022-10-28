import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/domain/repositories/message_repository.dart';

import '../../config/constants/urls.dart';
import '../models/message_model/message_model.dart';

class MessageRepositoryImpl extends MessageRepository {
  MessageRepositoryImpl(this.client);

  final CustomClient client;
  List<MessageModel> _messagesList = [];

  @override
  Future<void> getMessage() async {
    var response = await client.get(Url.getMessages);
    if (response.isSuccessful) {
      _messagesList = [
        for (final item in jsonDecode(response.body)['results']) MessageModel.fromJson(item),
      ];
    } else {
      throw VMException(response.body.parseError(), response: response, callFuncName: 'getMessage');
    }
  }

  @override
  List<MessageModel> get messagesList => _messagesList;
}
