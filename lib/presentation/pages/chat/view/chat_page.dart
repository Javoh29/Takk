import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/config/constants/assets.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/chat/viewmodel/chat_viewmodel.dart';
import 'package:takk/presentation/widgets/cache_image.dart';

class ChatPage extends ViewModelBuilderWidget<ChatViewModel> {
  ChatPage(
    this.chatId,
    this.name,
    this.image,
    this.isCreate,
    this.isOrder,
  );

  int chatId;
  final String name;
  final String image;
  final bool isCreate;
  final int? isOrder;

  @override
  Widget builder(BuildContext context, ChatViewModel viewModel, Widget? child) {
    viewModel.initState();
    bool isOnline = false;
    if (viewModel.messages != null && viewModel.messages!.isNotEmpty) {
      isOnline = viewModel.messages!.last.author!.isOnline ?? false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 5),
              child: CacheImage(
                image,
                fit: BoxFit.cover,
                placeholder: Image.asset(
                  Assets.images.appLogoCircle,
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.b6DemiBold.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: AppTextStyles.body12w6.copyWith(
                    color: isOnline ? AppColors.accentColor : AppColors.textColor.shade2,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => viewModel.pop(),
          icon: Icon(
            Ionicons.chevron_back_outline,
            size: 22,
            color: AppColors.textColor.shade1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.more_vert,
              size: 20,
              color: AppColors.textColor.shade1,
            ),
          ),
        ],
        backgroundColor: AppColors.scaffoldColor,
        leadingWidth: 50,
        elevation: 0,
      ),
      body: viewModel.isSuccess(tag: viewModel.tagLoadMessages)
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryLight.shade100,
                ),
              ),
            )
          : Stack(
              children: [
                if (viewModel.messages != null)
                  // ListView.builder(itemBuilder: (context, index) => , padding: const EdgeInsets.only(bottom: 60, top: 10,), physics: const BouncingScrollPhysics(),),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: AppColors.baseLight.shade100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accentColor,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Color(0x2500CE8D),
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: viewModel.isSuccess(tag: viewModel.tagSendMessage)
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.baseLight.shade100,
                                    )
                                  : Image.asset(
                                      Assets.icons.icSend,
                                      width: 20,
                                      height: 20,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  @override
  ChatViewModel viewModelBuilder(BuildContext context) {
    return ChatViewModel(
      context: context,
      chatRepository: locator.get(),
    );
  }
}
