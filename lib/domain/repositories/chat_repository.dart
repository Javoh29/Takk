import 'package:takk/data/models/message_model/last_message.dart';

import '../../data/models/cart_response.dart';

abstract class ChatRepository {

  Future<void> getMessageInfo(int id);

  Future<void> getOrderInfo(int id);

  Future<void> sendMessage(String value, int chatId, bool isFile);

  Future<int?> createChat(bool isOrder, int id);

  CartResponse get cartResponseOrder;

  List<LastMessage> get lastMessageList;

  set lastMessageList(List<LastMessage> lastMessageList) ;

}
