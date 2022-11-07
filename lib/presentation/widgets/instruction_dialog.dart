import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';

Future<T?> showInstructionDialog<T>(BuildContext context) {
  return showDialog(
      context: context,
      builder: (_) {
        String str = '';
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 200,
            height: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.baseLight.shade100, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Delivery instruction',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      isDense: true,
                      hintText: 'enter instruction',
                      hintStyle: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade3),
                    ),
                    minLines: 6,
                    maxLines: 6,
                    onChanged: (text) {
                      str = text;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                        )),
                    TextButton(
                        onPressed: () {
                          if (str.isNotEmpty) Navigator.pop(context, str);
                        },
                        child: Text(
                          'Add',
                          style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
