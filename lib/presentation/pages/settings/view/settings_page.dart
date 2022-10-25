import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/settings/viewmodel/settings_viewmodel.dart';
import '../../../widgets/cache_image.dart';

class SettingsPage extends ViewModelBuilderWidget<SettingPageViewModel> {
  SettingsPage({super.key});

  @override
  Widget builder(
      BuildContext context, SettingPageViewModel viewModel, Widget? child) {
    var model = locator<LocalViewModel>().userModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: AppTextStyles.body16w5.copyWith(letterSpacing: 0.5)),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => viewModel.pop(),
          icon: Icon(
            Ionicons.chevron_back_outline,
            size: 22,
            color: AppColors.textColor.shade1,
          ),
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent)),
          label: Text(
            'Back',
            style: AppTextStyles.body16w5,
          ),
        ),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: model != null
          ? ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                ListTile(
                  onTap: () {},
                  leading: CacheImage(model.avatar ?? '',
                      fit: BoxFit.cover,
                      height: 55,
                      width: 55,
                      borderRadius: 50,
                      placeholder: Image.asset(
                        'assets/icons/ic_user.png',
                        fit: BoxFit.cover,
                        height: 55,
                        width: 55,
                      )),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    model.username!,
                    style: AppTextStyles.body15w5,
                  ),
                  subtitle: Text(
                    model.phone!,
                    style: AppTextStyles.body15w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                  trailing: Icon(
                    Ionicons.chevron_forward_outline,
                    size: 20,
                    color: AppColors.textColor.shade1,
                  ),
                  tileColor: Colors.white,
                ),
                const SizedBox(height: 25),
                if (model.userType == 2 || model.userType == 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      onTap: () {},
                      leading: Icon(
                        Ionicons.people_outline,
                        size: 25,
                        color: AppColors.textColor.shade1,
                      ),
                      title: Text(
                        'Cashier view',
                        style: AppTextStyles.body14w5,
                      ),
                      trailing: Switch(
                        value: locator<LocalViewModel>().isCashier,
                        onChanged: (value) {},
                      ),
                      horizontalTitleGap: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Ionicons.card_outline,
                    size: 25,
                    color: AppColors.textColor.shade1,
                  ),
                  title: Text(
                    'Payment methods',
                    style: AppTextStyles.body14w5,
                  ),
                  trailing: Icon(
                    Ionicons.chevron_forward_outline,
                    size: 20,
                    color: AppColors.textColor.shade1,
                  ),
                  horizontalTitleGap: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () {},
                    leading: Icon(
                      Ionicons.notifications_outline,
                      size: 25,
                      color: AppColors.textColor.shade1,
                    ),
                    title: Text(
                      'Notifications',
                      style: AppTextStyles.body14w5,
                    ),
                    trailing: Icon(
                      Ionicons.chevron_forward_outline,
                      size: 20,
                      color: AppColors.textColor.shade1,
                    ),
                    horizontalTitleGap: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Ionicons.information_circle_outline,
                    size: 25,
                    color: AppColors.textColor.shade1,
                  ),
                  title: Text(
                    'About us',
                    style: AppTextStyles.body14w5,
                  ),
                  trailing: Icon(
                    Ionicons.chevron_forward_outline,
                    size: 20,
                    color: AppColors.textColor.shade1,
                  ),
                  horizontalTitleGap: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    onTap: () {},
                    leading: Icon(
                      Ionicons.share_outline,
                      size: 25,
                      color: AppColors.textColor.shade1,
                    ),
                    title: Text(
                      'Share & Earn',
                      style: AppTextStyles.body14w5,
                    ),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Ionicons.information_circle_outline,
                          size: 25,
                          color: AppColors.textColor.shade1,
                        )),
                    horizontalTitleGap: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                  ),
                ),
                ListTile(
                  onTap: () async {},
                  leading: const Icon(
                    Ionicons.log_out_outline,
                    size: 25,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Log out',
                    style:
                        AppTextStyles.body14w5.copyWith(color: AppColors.red),
                  ),
                  horizontalTitleGap: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.white,
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  SettingPageViewModel viewModelBuilder(BuildContext context) {
    return SettingPageViewModel(context: context);
  }
}