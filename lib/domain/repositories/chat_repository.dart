import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/data/models/message_model/message_model.dart';

import '../../data/models/cart_response.dart';

abstract class ChatRepository {
  Future<void> getMessageInfo(int id, bool isOrder);

  Future<void> getMessageCount(int id);

  Future<void> getOrderInfo(int id);

  Future<void> sendMessage(String value, int id, bool isFile);

  Future<void> sendOrderMessage(String value, int id, bool isFile);

  Future<void> getSelectedCompanyInfoForChat(int compId);

  CartResponse get cartResponseOrder;

  List<LastMessage> get lastMessageList;

  MessageModel get messageModel;

  set lastMessageList(List<LastMessage> lastMessageList);
}
