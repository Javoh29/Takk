import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/domain/repositories/message_repository.dart';

class MessagesViewModel extends BaseViewModel {
  MessagesViewModel({required super.context, required this.messageRepository});

  MessageRepository messageRepository;
  final GlobalKey<RefreshIndicatorState> refNew =
      GlobalKey<RefreshIndicatorState>();

  String curDate = '';
  late MessageModel model;

  initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => refNew.currentState!.show(),
    );
  }

  Future<void> getMessages(String tag) async {
    safeBlock(
      () async {
        await messageRepository.getMessage();
      },
      callFuncName: 'getMessages',
      tag: tag,
    );
  }
}
