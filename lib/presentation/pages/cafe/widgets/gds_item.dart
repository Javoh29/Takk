import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/models/product_model/product_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import 'cache_image.dart';

class GdsItem extends StatelessWidget {
  GdsItem({
    required this.e,
    super.key,
  });
  ProductModel e;

  @override
  Widget build(BuildContext context) {
    String price = '0';
    for (var element in e.sizes) {
      if (element.mDefault) {
        price = element.price;
      }
    }
    return Container(
      height: 85,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColor.shade3,
              blurRadius: 3,
            )
          ]),
      child: Row(
        children: [
          CacheImage(e.imageMedium ?? '',
              fit: BoxFit.cover,
              width: 64,
              borderRadius: 10,
              placeholder: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Ionicons.fast_food_outline,
                  size: 30,
                  color: AppColors.primaryLight,
                ),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      e.name ?? '',
                      style: AppTextStyles.body15w5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      e.description ?? '',
                      style: AppTextStyles.body12w4
                          .copyWith(color: AppColors.textColor.shade2),
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
          ),
          if (locator<LocalViewModel>().isCashier)
            Column(
              children: [
                Text(
                  '\$$price',
                  style: AppTextStyles.body14w5,
                ),
                Switch(value: e.available, onChanged: (value) {}
                    // setChangeState(e.id, !e.available),
                    )
              ],
            )
          else
            Text(
              '\$$price',
              style: AppTextStyles.body14w5,
            )
        ],
      ),
    );
  }
}