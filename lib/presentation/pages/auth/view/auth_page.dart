import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/auth/viewmodel/auth_viewmodel.dart';

import '../../../../core/di/app_locator.dart';
import '../../../widgets/scale_container.dart';

class AuthPage extends ViewModelBuilderWidget<AuthViewModel> {
  AuthPage({super.key});

  @override
  void onViewModelReady(AuthViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadLocalData();
  }

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffoldColor,
        leading: TextButton(
            onPressed: () {
              locator<LocalViewModel>().isGuest = true;
              viewModel.getCompanyInfo();
            },
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            child: Text(
              'Skip',
              style: AppTextStyles.body16w5,
            )),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => viewModel.setAuth(),
              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
              child: Text(
                'Next',
                style: AppTextStyles.body16w5,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/app_logo.svg',
                height: 100,
                color: AppColors.textColor.shade3,
              )),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Welcome to Takk',
                  style: AppTextStyles.head16wB.copyWith(fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Enter your phone number to login or create an account',
                  style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                ),
              ),
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.textColor.shade2, width: 1),
                  boxShadow: const [
                    BoxShadow(color: Color(0xffECECEC), offset: Offset(0, 0), blurRadius: 10),
                  ],
                ),
                child: Row(
                  children: [
                    ScaleContainer(
                      onTap: () {
                        viewModel.isOpenDrop = !viewModel.isOpenDrop;
                      },
                      child: Container(
                        height: 55,
                        width: 80,
                        padding: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: AppColors.textColor.shade3,
                          borderRadius:
                              const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/flags/${viewModel.selectCountry.code.toLowerCase()}.png',
                                width: 30,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                viewModel.isOpenDrop ? Ionicons.chevron_up_outline : Ionicons.chevron_down_outline,
                                size: 16,
                                color: AppColors.textColor.shade1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        autofocus: true,
                        cursorColor: AppColors.textColor.shade1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixText: '+${viewModel.selectCountry.dialCode}  ',
                          prefixStyle: AppTextStyles.body16w5,
                          labelText: 'Phone number*',
                          labelStyle: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                          suffixIcon: viewModel.isValidate
                              ? const Icon(
                                  Icons.error_outline,
                                  size: 25,
                                  color: Colors.redAccent,
                                )
                              : null,
                        ),
                        onSubmitted: (text) {
                          viewModel.setAuth();
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(viewModel.selectCountry.maxLength),
                        ],
                        onChanged: (text) {
                          viewModel.phoneNumber = text;
                        },
                        style: AppTextStyles.body16w5,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ),
              if (viewModel.isOpenDrop && viewModel.listCountryAll.isNotEmpty)
                Container(
                  width: double.infinity,
                  height:
                      viewModel.listCountrySort.length >= 3 ? 280 : ((viewModel.listCountrySort.length + 1) * 50) + 20,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12, width: 1),
                    boxShadow: const [
                      BoxShadow(color: Color(0xffECECEC), offset: Offset(0, 0), blurRadius: 10),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Ionicons.search_outline,
                              size: 22,
                              color: Colors.black38,
                            ),
                            hintText: 'Search for countries',
                            hintStyle:
                                AppTextStyles.body18w4.copyWith(fontSize: 16, color: AppColors.textColor.shade26),
                            prefixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 45),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 0.8),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 0.8),
                            ),
                          ),
                          onChanged: viewModel.searchCountry,
                          cursorColor: Colors.grey,
                          style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade54),
                        ),
                        Expanded(
                          child: Scrollbar(
                            radius: const Radius.circular(5),
                            child: ListView.builder(
                                itemCount: viewModel.listCountrySort.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        viewModel.setCountryModel(index);
                                      },
                                      leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.asset(
                                            'assets/flags/${viewModel.listCountrySort[index].code.toLowerCase()}.png',
                                            height: 30,
                                          )),
                                      title: Text(
                                        '${viewModel.listCountrySort[index].name} (+${viewModel.listCountrySort[index].dialCode})',
                                        style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade54),
                                      ),
                                    )),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) {
    return AuthViewModel(context: context, authRepository: locator.get());
  }
}
