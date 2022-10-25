import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:takk/data/models/product_model.dart';
import 'package:takk/presentation/pages/cafe/widgets/gds_item.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/ctg_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../widgets/cache_image.dart';

class CafeProductsItem extends StatelessWidget {
  CafeProductsItem({
    required this.data,
    required this.index,
    required this.isFavotrite,
    required this.autoScrollController,
    super.key,
  });
  dynamic data;
  int index;
  bool isFavotrite;
  AutoScrollController autoScrollController;
  @override
  Widget build(BuildContext context) {
    if (data['type'] == 0) {
      var ctg = CtgModel.fromJson(data['category']);
      // _mapIndex[ctg.id] = index;
      return AutoScrollTag(
        key: ValueKey(ctg.id),
        controller: autoScrollController,
        index: index,
        child: Text(
          ctg.name,
          style: AppTextStyles.body18w6
              .copyWith(color: AppColors.textColor.shade2),
        ),
      );
    } else if (data['type'] == 1) {
      var ctgSub = CtgModel.fromJson(data['subcategory']);
      return Container(
        color: Colors.white,
        height: 100,
        width: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            CacheImage(ctgSub.imageMedium ?? '',
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
                borderRadius: 12,
                placeholder: Text(
                  ctgSub.name,
                  style: AppTextStyles.body20w6
                      .copyWith(color: AppColors.textColor.shade2),
                )),
            Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  ctgSub.name,
                  style: AppTextStyles.body20w6
                      .copyWith(color: AppColors.textColor.shade2),
                ))
          ],
        ),
      );
    } else {
      List<ProductModel> list = [];
      for (final item in data['products']) {
        try {
          list.add(ProductModel.fromJson(item));
        } catch (e) {
          print(e);
        }
      }

      return Column(
        children: list.map((e) {
          return GestureDetector(
            onTap: () {},
            child: !locator<LocalViewModel>().isCashier &&
                    !isFavotrite &&
                    !e.available
                ? Stack(
                    children: [
                     GdsItem(e: e),
                      Container(
                        height: 85,
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text('The product is not available',
                            style: AppTextStyles.body13w5,
                            textAlign: TextAlign.center),
                      )
                    ],
                  )
                : GdsItem(e: e),
          );
        }).toList(),
      );
    }
  }
}
