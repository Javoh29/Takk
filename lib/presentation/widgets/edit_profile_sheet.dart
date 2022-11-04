import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/settings/viewmodel/settings_viewmodel.dart';

import 'cache_image.dart';

// ignore: must_be_immutable
class EditProfileSheet extends ViewModelBuilderWidget<SettingPageViewModel> {
  EditProfileSheet({super.key});

  final String  tag = 'EditProfileSheet';
  final TextEditingController _controller = TextEditingController();

  @override
  void onViewModelReady(SettingPageViewModel viewModel) {
    _controller.text = viewModel.userModel!.username ?? 'Name';
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
      BuildContext context, SettingPageViewModel viewModel, Widget? child) {
    return Material(
      color: AppColors.scaffoldColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => viewModel.pop(),
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.body16w5
                          .copyWith(color: AppColors.textColor.shade2),
                    )),
                TextButton(
                    onPressed: () =>
                        viewModel.setUserData(tag, _controller.text),
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      'Save',
                      style: AppTextStyles.body16w5
                          .copyWith(color: AppColors.textColor.shade2),
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () => viewModel.getImage(),
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 5)
                    ]),
                child: Stack(
                  children: [
                    viewModel.image == null
                        ? CacheImage(viewModel.userModel!.avatar ?? '',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            borderRadius: 50,
                            placeholder: Image.asset(
                              'assets/icons/ic_user.png',
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              viewModel.image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        Ionicons.camera_outline,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                )),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Phone number:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Text(
                  viewModel.userModel!.phone ?? '',
                  style: AppTextStyles.body16w5,
                )
              ],
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Name:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.textColor.shade2,
                      ),
                    ),
                    controller: _controller,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.body16w5,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Birth date:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      if (Platform.isIOS || Platform.isMacOS) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('Info'),
                            content: const Text(
                                'You will get a free drink on your birthday, which can be redeemed at one of the participating coffeeshops'),
                            actions: [
                              CupertinoButton(
                                  child:
                                      Text('OK', style: AppTextStyles.head15w4),
                                  onPressed: () => Navigator.pop(context))
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Info'),
                            content: const Text(
                                'You will get a free drink on your birthday, which can be redeemed at one of the participating coffeeshops'),
                            actions: [
                              TextButton(
                                  child:
                                      Text('OK', style: AppTextStyles.head15w4),
                                  onPressed: () => Navigator.pop(context))
                            ],
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Ionicons.information_circle,
                      size: 20,
                      color: AppColors.textColor.shade2,
                    )),
                Expanded(
                  child: Text(
                    viewModel.userModel!.dateOfBirthday != null && viewModel.selectDate == null
                        ? viewModel.userModel!.dateOfBirthday!
                        : viewModel.selectDate == null
                            ? 'Select'
                            : DateFormat('yyyy-MM-dd').format(viewModel.selectDate!),
                    style: AppTextStyles.body16w5,
                  ),
                ),
                IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () => viewModel.showDate(context),
                  icon: Icon(
                    Ionicons.chevron_down_outline,
                    color: AppColors.textColor.shade2,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xffF4F4F4), blurRadius: 5)
                ]),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Email:',
                    style: AppTextStyles.body16w5
                        .copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.edit,
                        size: 20,
                        color: AppColors.textColor.shade2,
                      ),
                    ),
                    // controller: _controller,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.body16w5,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onDestroy(SettingPageViewModel model) {
    _controller.dispose();
    super.onDestroy(model);
  }

  @override
  SettingPageViewModel viewModelBuilder(BuildContext context) {
    return SettingPageViewModel(context: context);
  }
}
