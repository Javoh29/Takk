import 'package:flutter/cupertino.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/emt_points/viewmodel/emt_points_viewmodel.dart';

class EmtPointsItemWidget extends ViewModelWidget<EmtPointsViewModel> {
  EmtPointsItemWidget({super.key, required this.number});

  int number;

  @override
  Widget build(BuildContext context, EmtPointsViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        if (viewModel.point != number) {
          viewModel.point = number;
        } else {
          viewModel.point = 0;
        }
        viewModel.notifyListeners();
      },
      child: Container(
        height: 55,
        width: 55,
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: viewModel.point == number
              ? AppColors.accentColor
              : AppColors.baseLight.shade100,
          borderRadius: BorderRadius.circular(27.5),
          border: Border.all(color: AppColors.accentColor, width: 2),
        ),
        child: Text(
          number.toString(),
          style: AppTextStyles.body16w5
              .copyWith(color: AppColors.textColor.shade1),
        ),
      ),
    );
  }
}
