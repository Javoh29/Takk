import 'package:takk/data/models/message_model/last_message.dart';

import '../../data/models/cart_response.dart';

abstract class ChatRepository {

  Future<List<LastMessage>?> getMessageInfo(String tag, int id);

  Future<CartResponse?> getOrderInfo(String tag, int id);
}
