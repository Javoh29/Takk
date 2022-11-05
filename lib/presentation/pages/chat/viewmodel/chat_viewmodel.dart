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
  ChatViewModel({
    required this.name,
    required this.image,
    required this.isCreate,
    this.isOrder,
    required super.context,
    required this.chatRepository,
    required this.chatId,
    required this.compId,
  });

  ChatRepository chatRepository;

  Future? dialog;
  File? fileImage;
  final picker = ImagePicker();
  bool isOnline = false;

  final String tagLoadMessages = 'LoadMessages';
  final String tagSendMessage = 'SendMessage';
  final String tagCompGetInfo = 'companiesGetInfo';

  int? chatId;
  int? compId;
  String? name;
  String? image;
  final bool isCreate;
  final int? isOrder;
  bool needsScroll= true;

  void initState() {
    if (isCreate) {
      getSelectedCompanyInfoForChat();
    } else {
      loadMessages();
    }
  }

  getSelectedCompanyInfoForChat() {
    safeBlock(() async {
      // companiya id siga qarab cafe malumotlari olinayapti.
      await chatRepository.getSelectedCompanyInfoForChat(compId!);
      chatId = chatRepository.messageModel.id;
      if (isOrder == null) {
        name = chatRepository.messageModel.company!.name;
        image = chatRepository.messageModel.image;
      }
      setSuccess(tag: tagCompGetInfo);
      loadMessages();
    }, callFuncName: 'backToChat', tag: tagCompGetInfo);
  }

  loadMessages() {
    safeBlock(() async {
      await chatRepository.getMessageInfo(chatId!, isOrder!=null);
      if (isOrder != null) {
        chatRepository.lastMessageList.add(LastMessage(text: 'Order: $chatId'));
      }
      setSuccess(tag: tagLoadMessages);
      if (chatRepository.lastMessageList.isNotEmpty && isOrder == null) {
        isOnline = chatRepository.lastMessageList.last.author!.isOnline ?? false;
      }
    }, callFuncName: 'loadMessages', tag: tagLoadMessages);
  }

  Future<void> sendMessage(String text) async {
    String sentValue = fileImage != null ? fileImage!.path : text;
    if (!isBusy(tag: tagSendMessage) &&
        (sentValue.isNotEmpty || fileImage != null)) {
      safeBlock(
        () async {
          if (isOrder == null) {
            await chatRepository.sendMessage(
                sentValue, compId!, fileImage != null);
          } else {
            await chatRepository.sendOrderMessage(
                sentValue, isOrder!, fileImage != null);
          }
          fileImage = null;
          setSuccess(tag: tagSendMessage);
        },
        callFuncName: 'sendMessage',
        tag: tagSendMessage,
      );
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    notifyListeners();
    debugPrint("get Image");
    if (pickedFile != null) {
      fileImage = File(pickedFile.path);
    } else {
      debugPrint("No image selected");
    }
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (tag != tagSendMessage) {
      if (isBusy(tag: tag)) {
        Future.delayed(Duration.zero, () {
          dialog = showLoadingDialog(context!);
        });
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
