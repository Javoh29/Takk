import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../../domain/repositories/cart_repository.dart';
import '../../../components/back_to_button.dart';

class CustomAppBar extends ViewModelWidget<CafeViewModel> with PreferredSizeWidget {
  final CafeModel cafeModel;
  final bool isFavorite;
  final String _tag = 'checkTimestamp';

  CustomAppBar({
    required this.cafeModel,
    required this.isFavorite,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, CafeViewModel viewModel) {
    return AppBar(
      backgroundColor: AppColors.scaffoldColor,
      elevation: 0,
      title: Text(
        cafeModel.name ?? '',
        style: AppTextStyles.body16w5,
      ),
      centerTitle: true,
      leadingWidth: 90,
      leading: BackToButton(
        title: 'Back',
        color: TextColor().shade1,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        if (!isFavorite)
          SizedBox(
            width: 45,
            height: 60,
            child: IconButton(
              onPressed: () {
                viewModel.navigateTo(Routes.cafeInfoPage, arg: {'cafe_info_model': cafeModel});
              },
              icon: Icon(
                Ionicons.information_circle_outline,
                size: 25,
                color: AppColors.textColor.shade2,
              ),
            ),
          ),
        if (!locator<LocalViewModel>().isCashier && !isFavorite)
          Badge(
            position: BadgePosition.topEnd(top: 2, end: 2),
            animationDuration: const Duration(milliseconds: 500),
            alignment: Alignment.topRight,
            elevation: 0,
            animationType: BadgeAnimationType.slide,
            showBadge: locator<CartRepository>().cartList.isNotEmpty,
            badgeColor: Colors.redAccent,
            badgeContent: const Text(
              '3',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11, height: 1),
            ),
            child: Container(
              height: 60,
              width: 45,
              child: IconButton(
                onPressed: () {
                  viewModel.basketFunction(_tag, context, cafeModel);
                },
                icon: Icon(
                  Ionicons.cart_outline,
                  size: 25,
                  color: AppColors.textColor.shade2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
