import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/domain/repositories/chat_repository.dart';

import '../../../../data/models/cart_response_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel({required super.context, required this.chatRepository});

  final String tagLoadMessages = 'LoadMessages';
  final String tagSendMessage = 'SendMessage';
  final String tag = 'OrderInfoSheet';
  CartResponse? model;

  final TextEditingController _textEditingController = TextEditingController();
  List<LastMessage>? messages = [];
  File? image;
  final picker = ImagePicker();
  bool isOnline = false;
  ChatRepository chatRepository;

  Future<void> loadMessage() async {
    if (locator<LocalViewModel>().lastMessageList.isNotEmpty) {
      messages = locator<LocalViewModel>().lastMessageList;
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    debugPrint("get Image");
    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      debugPrint("No image selected");
    }
  }

  

  initState() {
    loadMessage();
    getImage();
    
  }

}
