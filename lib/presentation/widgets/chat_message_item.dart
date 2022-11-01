import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:takk/presentation/widgets/cache_image.dart';

import '../../core/di/app_locator.dart';
import '../../data/models/message_model/last_message.dart';

class ChatMessageItem extends StatelessWidget {
  ChatMessageItem({super.key, required this.model, required this.isOrder});

  final LastMessage model;
  final int? isOrder;

  @override
  Widget build(BuildContext context) {
    if (model.id == null) {
      return Center(
        child: InkWell(
          onTap: () {
            // showModalBottomSheet(
            //     context: context,
            //     builder: (context) => OrderInfoSheet(isOrder ?? 0));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                color: const Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(15)),
            child: Text(
              model.text ?? '',
              style: AppTextStyles.body13w6
                  .copyWith(color: AppColors.textColor.shade2),
            ),
          ),
        ),
      );
    } else {
      if (model.author?.id! == locator<UserRepository>().userModel!.id!) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(100, 10, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                padding: model.files != null && model.files!.isNotEmpty
                    ? const EdgeInsets.all(2)
                    : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: AppColors.accentColor),
                child: model.files != null && model.files!.isNotEmpty
                    ? CacheImage(
                        model.files?.first.file ?? '',
                        placeholder: const Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.white,
                        ),
                        borderRadius: 18,
                      )
                    : Text(
                        model.text != null
                            ? utf8.decode(model.text!.codeUnits)
                            : 'null',
                        style: AppTextStyles.body15w5
                            .copyWith(color: Colors.white),
                      ),
              ),
              Text(
                DateFormat('HH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(model.createdDt ?? 0)),
                style: AppTextStyles.body11w5
                    .copyWith(color: AppColors.textColor.shade2),
              )
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 100, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 2),
                padding: model.files != null && model.files!.isNotEmpty
                    ? const EdgeInsets.all(2)
                    : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                    color: Color(0xffEDEDED)),
                child: model.files != null && model.files!.isNotEmpty
                    ? CacheImage(
                        model.files?.first.file ?? '',
                        placeholder: const Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.white,
                        ),
                        borderRadius: 18,
                      )
                    : Text(
                        model.text != null
                            ? utf8.decode(model.text!.codeUnits)
                            : 'null',
                        style: AppTextStyles.body15w5
                            .copyWith(color: Colors.white),
                      ),
              ),
              Text(
                DateFormat('HH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(model.createdDt ?? 0)),
                style: AppTextStyles.body11w5
                    .copyWith(color: AppColors.textColor.shade2),
              )
            ],
          ),
        );
      }
    }
  }
}
