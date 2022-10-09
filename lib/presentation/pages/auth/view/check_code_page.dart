import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/auth/viewmodel/auth_viewmodel.dart';

import '../../../../data/models/country_model.dart';

class CheckCodePage extends ViewModelBuilderWidget<AuthViewModel> {
  CheckCodePage({required this.phoneNumber, required this.countryModel, super.key});
  final String phoneNumber;
  final CountryModel countryModel;

  @override
  void onViewModelReady(AuthViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.phoneNumber = phoneNumber;
    viewModel.selectCountry = countryModel;
  }

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Ionicons.chevron_back_outline,
                  size: 22,
                  color: AppColors.textColor.shade2,
                ),
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                label: Text(
                  'Back',
                  style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade2),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: Text(
                'Confirm Your Number',
                style: AppTextStyles.head16wB.copyWith(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
              child: Text(
                'We just send you a six code via SMS to confirm your phone number',
                style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '••••••',
                  hintStyle: AppTextStyles.body16w5.copyWith(color: Colors.black26, letterSpacing: 1.5),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor.shade3, width: 0.8),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textColor.shade3, width: 0.8),
                  ),
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text(
                      'Code',
                      style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade2),
                    ),
                  ),
                ),
                onChanged: (text) {
                  if (text.length == 6) {
                    viewModel.setAuth(code: text);
                  }
                },
                style: AppTextStyles.body16w5,
                maxLength: 6,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  'Didn\'t get the code?',
                  style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade3),
                )),
            Align(
                alignment: Alignment.center,
                child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          'Send it again',
                          style: AppTextStyles.body16w5,
                        ))))
          ],
        ),
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) {
    return AuthViewModel(context: context, authRepository: locator.get());
  }
}
