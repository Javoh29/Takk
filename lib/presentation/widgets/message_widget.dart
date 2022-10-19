import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/presentation/routes/routes.dart';

import 'cache_image.dart';

class MessageWidgetPage extends StatefulWidget {
  MessageWidgetPage({
    super.key,
    required this.refNew,
    required this.model,
  });

  final GlobalKey<RefreshIndicatorState> refNew;
  MessageModel model;

  @override
  State<MessageWidgetPage> createState() => _MessageWidgetPageState();
}

class _MessageWidgetPageState extends State<MessageWidgetPage> {
  
  late var date = DateTime.fromMillisecondsSinceEpoch(widget.model.lastMessage?.createdDt ?? 0);
  bool isOnline = false;

  void isOnlineFunc(MessageModel model) {
    if (model.company != null) {
      isOnline = widget.model.company!.isOnline ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.chatPage, arguments: {
        "chatId": widget.model.id,
        'name': widget.model.title,
        'image': widget.model.image ?? '',
        'isCreate': false,
        'isOrder': widget.model.order
      }).then(
        (value) => widget.refNew.currentState!.show(),
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
                  widget.model.image ?? '',
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
                    color: isOnline ? AppColors.accentColor : TextColor().shade2,
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
                      widget.model.title ?? '',
                      style: AppTextStyles.body18w6,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (widget.model.lastMessage != null)
                      Flexible(
                        child: widget.model.lastMessage?.files == null || widget.model.lastMessage!.files!.isEmpty
                            ? Text(
                                widget.model.lastMessage!.text != null
                                    ? utf8.decode(widget.model.lastMessage!.text!.codeUnits)
                                    : 'null',
                                style: AppTextStyles.body16w5.copyWith(
                                  color: widget.model.unreadMessagesCount != 0
                                      ? AppColors.accentColor
                                      : TextColor().shade2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                '🌇 image',
                                style: AppTextStyles.body16w5.copyWith(
                                  color: widget.model.unreadMessagesCount != 0
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
          ],
        ),
      ),
    );
  }
}
