import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/domain/repositories/message_repository.dart';

class MessegesViewModel extends BaseViewModel {
  MessegesViewModel({required super.context, required this.messageRepository});

  MessageRepository messageRepository;
  final GlobalKey<RefreshIndicatorState> refNew = GlobalKey<RefreshIndicatorState>();
  final String tag = 'MessagesPage';
  String curDate = '';
  late MessageModel model;

  initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => refNew.currentState!.show(),
    );
  }

  Future<void> getMessages() async {
    safeBlock(
      () async {
        await messageRepository.getMessage();
      },
    );
  }
}
