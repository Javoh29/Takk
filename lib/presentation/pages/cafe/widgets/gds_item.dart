import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/product_model.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../widgets/cache_image.dart';

class GdsItem extends ViewModelWidget<CafeViewModel> {
  GdsItem({
    required this.e,
    this.isFavotrite,
    this.cafeModel,
    this.index,
    super.key,
  });

  final ProductModel e;
  bool? isFavotrite;
  CafeModel? cafeModel;
  int? index;

  @override
  Widget build(BuildContext context, CafeViewModel viewModel) {
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
                Switch(
                  value: e.available,
                  onChanged: (value) {
                    viewModel.cafeProductItemFunction(
                      isFavorite: isFavotrite!,
                      available: e.available,
                      context: context,
                      cafeModel: cafeModel!,
                      productModel: e,
                    );
                  },
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
