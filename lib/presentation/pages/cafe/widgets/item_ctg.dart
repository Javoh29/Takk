import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:marquee/marquee.dart';
import 'package:takk/data/models/cafe_model/ctg_model.dart';
import 'package:takk/presentation/pages/cafe/widgets/cache_image.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';

class ItemCtg extends StatelessWidget {
   ItemCtg({required this.model, super.key});
  CtgModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 70,
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.textColor.shade3),
              child: CacheImage(model.imageMedium ?? '',
                  fit: BoxFit.cover,
                  borderRadius: 8,
                  placeholder: Icon(
                    Ionicons.fast_food_outline,
                    size: 30,
                    color: AppColors.primaryLight,
                  )),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: model.name.length > 13
                  ? Marquee(
                      text: model.name,
                      velocity: 10,
                      blankSpace: 10,
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      style: AppTextStyles.body11w5,
                    )
                  : Text(
                      model.name,
                      style: AppTextStyles.body11w5,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
