import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:marquee/marquee.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:takk/data/models/cafe_model/ctg_model.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';
import 'package:takk/presentation/widgets/cache_image.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';

class ItemCtg extends StatelessWidget {
  ItemCtg({required this.model, required this.viewModel,required this.autoScrollController, super.key});
  CtgModel model;
  CafeViewModel viewModel;
  AutoScrollController autoScrollController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.funcScrollByCtg(
          autoScrollController, viewModel.mapIndex[model.id] ?? 0),
      child: SizedBox(
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
