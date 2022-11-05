import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/presentation/pages/messeges/viewmodel/messeges_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';

import 'cache_image.dart';

class MessageItem extends StatelessWidget {
  MessageItem({
    super.key,
    required this.model,
    required this.viewModel,
  });

  MessagesViewModel viewModel;
  MessageModel model;

  late var date =
      DateTime.fromMillisecondsSinceEpoch(model.lastMessage?.createdDt ?? 0);
  bool isOnline = false;

  void isOnlineFunc(MessageModel model) {
    if (model.company != null) {
      isOnline = model.company!.isOnline ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.chatPage, arguments: {
        "compId" : model.company!.id,
        "chatId": model.id,
        'name': model.title,
        'image': model.image ?? '',
        'isCreate': false,
        'isOrder': model.order
      }).then(
        (value) => viewModel.refNew.currentState!.show(),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        width: double.infinity,
        height: 80,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CacheImage(
                  model.image ?? '',
                  fit: BoxFit.cover,
                  placeholder: Image.asset(
                    'assets/images/app_logo_circle.png',
                    height: 55,
                    width: 55,
                  ),
                  height: 55,
                  width: 55,
                  borderRadius: 30,
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isOnline ? AppColors.accentColor : TextColor().shade2,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.title ?? '',
                      style: AppTextStyles.body18w6,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (model.lastMessage != null)
                      Flexible(
                        child: model.lastMessage?.files == null ||
                                model.lastMessage!.files!.isEmpty
                            ? Text(
                                model.lastMessage!.text != null
                                    ? utf8.decode(
                                        model.lastMessage!.text!.codeUnits)
                                    : 'null',
                                style: AppTextStyles.body16w5.copyWith(
                                  color: model.unreadMessagesCount != 0
                                      ? AppColors.accentColor
                                      : TextColor().shade2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                '🌇 image',
                                style: AppTextStyles.body16w5.copyWith(
                                  color: model.unreadMessagesCount != 0
                                      ? AppColors.accentColor
                                      : TextColor().shade2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  viewModel.curDate == DateFormat('dd-MM-yyyy').format(date)
                      ? DateFormat().add_jm().format(date)
                      : DateFormat('dd-MM-yyyy').format(date),
                  style: AppTextStyles.body12w5
                      .copyWith(color: AppColors.textColor.shade2),
                ),
                if (model.unreadMessagesCount != 0)
                  Badge(
                    badgeContent: Text(
                      model.unreadMessagesCount.toString(),
                      style: AppTextStyles.body12w6
                          .copyWith(color: AppColors.textColor.shade3),
                    ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(10),
                    badgeColor: AppColors.accentColor,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
