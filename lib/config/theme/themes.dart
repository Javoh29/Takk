import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

abstract class Themes {
  const Themes._();
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.scaffoldColor,
      colorScheme: ColorScheme.light(
        secondary: AppColors.primaryLight.shade100,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.baseLight.shade100,
        centerTitle: true,
        titleTextStyle: AppTextStyles.body16w5,
        iconTheme: IconThemeData(
          color: AppColors.textColor.shade1,
        ),
      ),
      primaryColor: AppColors.primaryLight.shade100,
      fontFamily: 'OpenSans',
      dividerColor: Colors.transparent,
      tabBarTheme: TabBarTheme(
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.primaryLight.shade50,
            ),
          ),
        ),
        labelPadding: const EdgeInsets.all(12.0),
        labelColor: AppColors.primaryLight.shade50,
        labelStyle: AppTextStyles.b3Medium,
        unselectedLabelColor: AppColors.textColor.shade2,
        unselectedLabelStyle: AppTextStyles.b3Medium,
      ),
    );
  }
}
