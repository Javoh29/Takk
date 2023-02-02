import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';

Future<T?> showAddFavoriteDialog<T>(BuildContext context) {
  String name = '';
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Wrap(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Text(
                  'Add to favorite',
                  style: AppTextStyles.body16w6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                    'Save your favorite order so you check out faster next time.',
                    style: AppTextStyles.body14w6
                        .copyWith(color: AppColors.textColor.shade2),
                    textAlign: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.textColor.shade1, width: 1),
                        ),
                        isDense: true,
                        labelText: 'Enter favorite name',
                        labelStyle: AppTextStyles.body14w5
                            .copyWith(color: AppColors.textColor.shade2)),
                    onChanged: (text) {
                      name = text;
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {
                        if (name.isNotEmpty) {
                          Navigator.pop(context, name);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF1EC892)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Add',
                        style: AppTextStyles.body16w6,
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
