import 'package:takk/data/models/cart_response_model.dart';
import 'package:takk/data/models/message_model/last_message.dart';

abstract class ChatRepository {
  Future<List<LastMessage>?> getMessageInfo(String tag, int id);
  Future<CartResponse?> getOrderInfo(String tag, int id);
}
