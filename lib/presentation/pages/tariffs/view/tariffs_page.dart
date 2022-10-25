import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/tariffs/viewmodel/tariffs_viewmodel.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../routes/routes.dart';

class TariffsPage extends ViewModelBuilderWidget<TariffsViewModel> {
  @override
  void onViewModelReady(TariffsViewModel viewModel) {
    viewModel.getTariffs();
  }

  @override
  Widget builder(
      BuildContext context, TariffsViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cafe Budget balance',
          style: AppTextStyles.body16w5.copyWith(letterSpacing: 0.5),
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context, true),
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
            )),
        centerTitle: true,
        leadingWidth: 90,
        actions: [
          IconButton(
              onPressed: () => showTopSnackBar(
                    context,
                    const CustomSnackBar.info(
                      message:
                          "Cafe Budget makes it easy for you to set a spending budget, enable automatic balance refills, earn loyalty rewards, while helping your coffeeshop save on transaction fees.",
                    ),
                  ),
              icon: Icon(
                Icons.info_outline,
                color: AppColors.textColor.shade1,
                size: 22,
              ))
        ],
      ),
      //TODO: there was a future builder to listen to the result of getdata
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
                child: Text(
                  'Current balance',
                  style: AppTextStyles.body15w5,
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                onTap: () => viewModel.navigateTo(Routes.cashBackStaticPage),
                trailing: Icon(
                  Ionicons.chevron_forward_outline,
                  size: 20,
                  color: AppColors.textColor.shade2,
                ),
                title: Text(
                  '\$${locator<LocalViewModel>().userModel!.balance}',
                  style: AppTextStyles.body15w5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  'Add to your balance',
                  style: AppTextStyles.body15w5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: Text(
                  'How much do you want to add to your Cafe Budget balance?',
                  style: AppTextStyles.body14w5
                      .copyWith(color: AppColors.textColor.shade2),
                ),
              ),
              ListTile(
                tileColor: Colors.white,
                onTap: () {
                  viewModel.isAutoFill = !viewModel.isAutoFill;
                  viewModel.notifyListeners();
                },
                trailing: Switch(
                    value: viewModel.isAutoFill,
                    onChanged: (value) {
                      viewModel.isAutoFill = !viewModel.isAutoFill;
                      viewModel.notifyListeners();
                    }),
                title: Text(
                  'Auto fill',
                  style: AppTextStyles.body15w5,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 15, bottom: 15, top: 5, right: 15),
                  child: Text(
                    'If auto fill is activated, your card will be charged automatically to top up your Cafe Budget balance when it falls below \$10',
                    style: AppTextStyles.body14w5
                        .copyWith(color: AppColors.textColor.shade2),
                  )),
              ...locator<LocalViewModel>().tariffsList.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 1.5),
                    child: ListTile(
                      onTap: () {
                        viewModel.tId = e.id!;
                        viewModel.notifyListeners();
                      },
                      tileColor: Colors.white,
                      dense: true,
                      title: Text(
                        '\$${e.amountReceipt}',
                        style: AppTextStyles.body15w5,
                      ),
                      // subtitle: Text(
                      //   '${e.percent}% off (Pay \$${e.amountPayout})',
                      //   style: kTextStyle(
                      //       color: textColor2,
                      //       size: 15,
                      //       fontWeight: FontWeight.w500),
                      // ),
                      trailing: Radio(
                          value: e.id!,
                          groupValue: viewModel.tId,
                          onChanged: (value) {
                            viewModel.tId = e.id!;
                            viewModel.notifyListeners();
                          }),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                child: Text(
                  'Payment cards',
                  style: AppTextStyles.body15w5,
                ),
              ),
              ...locator<LocalViewModel>().cardList.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 1.5),
                    child: ListTile(
                      onTap: () {
                        viewModel.cId = e.id!;
                        viewModel.notifyListeners();
                      },
                      title: Text(
                        '${e.brand}  ****  ${e.last4}',
                        style: AppTextStyles.body16w5,
                      ),
                      leading: Icon(
                        Ionicons.card_outline,
                        size: 25,
                        color: AppColors.textColor.shade1,
                      ),
                      tileColor: Colors.white,
                      trailing: Radio(
                          value: e.id!,
                          groupValue: viewModel.cId,
                          onChanged: (value) {
                            viewModel.cId = e.id!;
                            viewModel.notifyListeners();
                          }),
                    ),
                  )),
              ListTile(
                onTap: () async {
                  viewModel.addNewCard();
                },
                contentPadding: const EdgeInsets.fromLTRB(17, 0, 30, 0),
                title: Text(
                  'Add new card',
                  style: AppTextStyles.body16w5,
                ),
                leading: const Icon(
                  Ionicons.card_outline,
                  size: 25,
                  color: AppColors.accentColor,
                ),
                tileColor: Colors.white,
                trailing: const Icon(
                  Ionicons.chevron_forward,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              )
            ],
          ),
          Container(
            height: 45,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            child: TextButton(
              onPressed: () => viewModel.confirm(),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
                  backgroundColor: MaterialStateProperty.all(viewModel.cId == 0
                      ? AppColors.textColor.shade2
                      : const Color(0xFF1EC892))),
              child: Text('CONFIRM',
                  style: AppTextStyles.body15w6.copyWith(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  TariffsViewModel viewModelBuilder(BuildContext context) {
    return TariffsViewModel(context: context, tariffsRepository: locator.get());
  }
}
