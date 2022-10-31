import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';

import '../../../../data/models/cafe_model/working_day.dart';

Future<T?> showWorkGraphDialog<T>(
    BuildContext context, List<WorkingDay> list) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
              child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              list[index].day ?? '',
                              style:AppTextStyles.body14w5,
                            ),
                            Text(
                              '${list[index].openingTime!.substring(0, 5)} - ${list[index].closingTime!.substring(0, 5)}',
                              style:AppTextStyles.body14w5,
                            )
                          ],
                        ),
                      ),
                  separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          color: AppColors.textColor.shade2,
                        ),
                      ),
                  itemCount: list.length),
            ),
          ),
        );
      });
}
