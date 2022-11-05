import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/chat/viewmodel/chat_viewmodel.dart';
import 'package:takk/presentation/widgets/cache_image.dart';
import 'package:takk/presentation/widgets/chat_message_item.dart';

// ignore: must_be_immutable
class ChatPage extends ViewModelBuilderWidget<ChatViewModel> {
  ChatPage(
      {required this.compId,
      required this.chatId,
      required this.name,
      required this.image,
      required this.isCreate,
      this.isOrder,
      super.key});

  int compId;
  int chatId;
  final String name;
  final String image;
  final bool isCreate;
  final int? isOrder;

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onViewModelReady(ChatViewModel viewModel) {
    viewModel.initState();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, ChatViewModel viewModel, Widget? child) {
    // if (viewModel.needsScroll) {
    // TODO: scroolni jumbTo buttonga qilish kerak
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.maxScrollExtent);
      viewModel.needsScroll = false;
    });
    // }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 5),
              child: CacheImage(
                viewModel.image!,
                fit: BoxFit.cover,
                placeholder: Image.asset(
                  'assets/images/app_logo_circle.png',
                  height: 40,
                  width: 40,
                ),
                height: 40,
                width: 40,
                borderRadius: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body18w7,
                ),
                Text(
                  viewModel.isOnline ? 'Online' : 'Offline',
                  style: AppTextStyles.body12w6.copyWith(color: AppColors.textColor.shade2),
                )
              ],
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.more_vert,
                size: 20,
                color: AppColors.textColor.shade1,
              ))
        ],
        backgroundColor: AppColors.scaffoldColor,
        leadingWidth: 50,
        elevation: 0,
      ),
      body: viewModel.isSuccess(tag: viewModel.tagLoadMessages)
          ? Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 75, top: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (viewModel.isOrder == null && viewModel.chatRepository.lastMessageList[index].orderId == null) {
                      return ChatMessageItem(
                        model: viewModel.chatRepository.lastMessageList[index],
                        isOrder: isOrder,
                      );
                    } else if (viewModel.isOrder != null &&
                        viewModel.chatRepository.lastMessageList[index].orderId != null) {
                      return ChatMessageItem(
                        model: viewModel.chatRepository.lastMessageList[index],
                        isOrder: isOrder,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: viewModel.chatRepository.lastMessageList.length,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (viewModel.fileImage == null) {
                              viewModel.getImage();
                            } else {
                              viewModel.fileImage = null;
                              viewModel.notifyListeners();
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            child: viewModel.fileImage != null
                                ? Image.file(viewModel.fileImage!)
                                : Image.asset(
                                    'assets/icons/ic_camera.png',
                                    height: 25,
                                    width: 25,
                                  ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          margin: const EdgeInsets.only(left: 10, right: 20),
                          color: AppColors.textColor.shade2,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _textEditingController,
                            enabled: viewModel.fileImage == null,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type something...',
                                hintStyle: AppTextStyles.body14w6.copyWith(color: AppColors.textColor.shade2)),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await viewModel.sendMessage(_textEditingController.text);
                            _textEditingController.clear();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.accentColor,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(blurRadius: 8, color: Color(0x2500CE8D), offset: Offset(0, 2))
                                ]),
                            child: viewModel.isBusy(tag: viewModel.tagSendMessage)
                                ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                : Image.asset(
                                    'assets/icons/ic_send.png',
                                    height: 20,
                                    width: 20,
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  void onDestroy(ChatViewModel model) {
    scrollController.dispose();
    super.onDestroy(model);
  }

  @override
  ChatViewModel viewModelBuilder(BuildContext context) {
    return ChatViewModel(
        context: context,
        chatRepository: locator.get(),
        image: image,
        compId: compId,
        isCreate: isCreate,
        name: name,
        isOrder: isOrder,
        chatId: chatId);
  }
}
