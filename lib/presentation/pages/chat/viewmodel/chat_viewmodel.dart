import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/chat_repository.dart';
import 'package:takk/presentation/widgets/loading_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/message_model/last_message.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel(
      {required this.name,
      required this.image,
      required this.isCreate,
      this.isOrder,
      required super.context,
      required this.chatRepository,
        required this.chatId});

  ChatRepository chatRepository;

  Future? dialog;
  File? fileImage;
  final picker = ImagePicker();
  bool isOnline = false;

  int? chatId;
  final String name;
  String? image;
  final bool isCreate;
  final int? isOrder;

  void initState(String tagMessage) {
    safeBlock(() async {
      if (isCreate) {
        chatRepository.createChat(isOrder != null, chatId!).then((value) {
          if (value is int) {
            chatId = value;
            loadMessages(tagMessage);
          }
        });
      } else {
        loadMessages(tagMessage);
      }
      isOnline = false;
      if (chatRepository.lastMessageList != null &&
          chatRepository.lastMessageList.isNotEmpty) {
        isOnline =
            chatRepository.lastMessageList.last.author!.isOnline ?? false;
      }
    }, callFuncName: 'initState', tag: tagMessage);
  }

  loadMessages(String tag) {
    safeBlock(() async {
      await chatRepository.getMessageInfo(chatId!);
      if (chatRepository.lastMessageList != null) {
        if (isOrder != null) {
          chatRepository.lastMessageList
              .add(LastMessage(text: 'Order: $chatId'));
        }
        setSuccess(tag: tag);
        chatRepository.lastMessageList =
            chatRepository.lastMessageList.reversed.toList();
        notifyListeners();
      }
    }, callFuncName: 'loadMessages', tag: tag);
  }

  sendMessage(String tag, String value, bool isFile) {
    safeBlock(() async {
      chatRepository.sendMessage(value, chatId!, isFile);
      setSuccess(tag: tag);
    }, callFuncName: 'sendMessage', tag: tag);
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    debugPrint("get Image");
    if (pickedFile != null) {
      fileImage = File(pickedFile.path);
    } else {
      debugPrint("No image selected");
    }
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
