import '../../data/models/message_model/message_model.dart';

abstract class MessageRepository {
  Future<void> getMessage();
  List<MessageModel> get messagesList;
}
