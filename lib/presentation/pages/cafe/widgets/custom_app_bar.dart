import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takk/domain/repositories/cart_repository.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../components/back_to_button.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, required this.cafeModel, required this.isFavorite})
      : super(key: key);

  final CafeModel cafeModel;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
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
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1),
            ),
            child: Container(
              height: 60,
              width: 45,
              child: IconButton(
                onPressed: () {},
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

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
