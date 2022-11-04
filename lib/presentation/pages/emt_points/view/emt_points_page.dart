import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/emt_points/viewmodel/emt_points_viewmodel.dart';
import 'package:takk/presentation/widgets/emt_points_item_widget.dart';

import '../../../routes/routes.dart';
import '../../../widgets/cache_image.dart';

class EmtPointsPage extends ViewModelBuilderWidget<EmtPointsViewModel> {
  EmtPointsPage({super.key});

  @override
  Widget builder(BuildContext context, EmtPointsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Give Points',
          style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
        ),
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text(
              'Back',
              style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
            )),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.navigateTo(Routes.qrcodeViewerPage).then((value) {
                viewModel.phone = value as String?;
              });
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Ionicons.scan_outline,
              size: 22,
              color: AppColors.textColor.shade2,
            ),
          ),
        ],
        backgroundColor: AppColors.scaffoldColor,
        leadingWidth: 90,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.baseLight.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.textColor.shade3,
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              onChanged: (value) {
                viewModel.phone = value;
              },
              style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                prefix: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    '+',
                    style: AppTextStyles.body18w5.copyWith(color: AppColors.textColor.shade1),
                  ),
                ),
                labelText: 'Tel number',
                hintText: 'X-XXX-XXXX',
                hintStyle: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade2),
              ),
            ),
            Divider(
              height: 30,
              color: AppColors.textColor.shade2,
            ),
            CacheImage(viewModel.companyLogo()!.logo ?? '',
                borderRadius: 30,
                fit: BoxFit.cover,
                height: 60,
                width: 60,
                placeholder: Image.asset(
                  'assets/images/app_logo_circle.png',
                  fit: BoxFit.cover,
                  height: 60,
                  width: 60,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Select point',
                style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EmtPointsItemWidget(number: 1),
                EmtPointsItemWidget(number: 2),
                EmtPointsItemWidget(number: 3),
                EmtPointsItemWidget(number: 4),
                EmtPointsItemWidget(number: 5),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EmtPointsItemWidget(number: 6),
                EmtPointsItemWidget(number: 7),
                EmtPointsItemWidget(number: 8),
                EmtPointsItemWidget(number: 9),
                EmtPointsItemWidget(number: 10),
              ],
            ),
            Container(
              height: 45,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 15),
              child: TextButton(
                onPressed: () {
                  viewModel.submitFunc();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xFF1EC892),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Text(
                  'SUBMIT',
                  style: AppTextStyles.body16w5.copyWith(color: AppColors.baseLight.shade100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  EmtPointsViewModel viewModelBuilder(BuildContext context) {
    return EmtPointsViewModel(
      context: context,
      companyRepository: locator.get(),
    );
  }
}
