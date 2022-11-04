import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../components/back_to_button.dart';
import '../../../routes/routes.dart';
import '../../../widgets/info_dialog.dart';
import '../viewmodel/payment_viewmodel.dart';

// ignore: must_be_immutable
class PaymentPage extends ViewModelBuilderWidget<PaymentViewModel> {
  PaymentPage({super.key, required this.isSelect});
  final bool isSelect;
  String tag = 'PaymentPageOld';
  bool isMain = true;

  @override
  void onViewModelReady(PaymentViewModel viewModel) {
    super.onViewModelReady(viewModel);
    if (isMain) {
      viewModel.getUserCards(tag);
    } else {
      viewModel.getUserData(tag);
    }
  }

  @override
  Widget builder(BuildContext context, PaymentViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment methods', style: AppTextStyles.body16w5),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: BackToButton(title: 'Back', color: TextColor().shade1, onPressed: () {
          viewModel.pop();
        },),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5, top: 20),
                child: Text(
                  'CAFE BUDGET',
                  style: AppTextStyles.body12w5,
                ),
              ),
              ListTile(
                onTap: () {
                  if (isSelect) {
                    Navigator.pop(context, {'name': 'Cafe budget', 'type': '0'});
                  } else {
                    Navigator.pushNamed(context, Routes.tariffsPage).then((value) {
                      if (value is bool) {
                        isMain = false;
                        viewModel.notifyListeners();
                      }
                    });
                  }
                },
                title: Row(
                  children: [
                    Text(
                      '\$${locator<UserRepository>().userModel!.balance}',
                      style: AppTextStyles.body16w5,
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () => showInfoDialog(context,
                            'Cafe Budget makes it easy for you to set a spending budget, enable automatic balance refills, earn loyalty rewards, while helping your coffeeshop save on transaction fees.'),
                        icon: Icon(
                          Icons.info_outline,
                          color: AppColors.textColor.shade1,
                          size: 22,
                        ))
                  ],
                ),
                trailing: Icon(
                  Ionicons.chevron_forward_outline,
                  size: 20,
                  color: AppColors.textColor.shade2,
                ),
                tileColor: Colors.white,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              ),
              if (isSelect)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                  child: Text(
                    'OTHER PAYMENT METHODS',
                    style: AppTextStyles.body12w5,
                  ),
                ),
              if (isSelect)
                ListTile(
                  onTap: () {
                    // if (Platform.isAndroid) {
                    //   model.getIsGooglePay().then((value) {
                    //     if (value != null && value) {
                    //       Navigator.pop(context, {'name': 'Google pay', 'type': '1'});
                    //     } else {
                    //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //         content: Text('You cannot pay from Google Pay for now'),
                    //         backgroundColor: Colors.redAccent,
                    //       ));
                    //     }
                    //   });
                    // } else {
                    //   Navigator.pop(context, {'name': 'Apple pay', 'type': '1'});
                    // }
                  },
                  leading: Icon(
                    Platform.isAndroid ? Ionicons.logo_google : Ionicons.logo_apple,
                    size: 25,
                    color: AppColors.textColor.shade1,
                  ),
                  title: Text(
                    Platform.isAndroid ? 'Google pay' : 'Apple pay',
                    style: AppTextStyles.body16w5,
                  ),
                  trailing: Icon(
                    Ionicons.chevron_forward_outline,
                    size: 20,
                    color: AppColors.textColor.shade2,
                  ),
                  tileColor: Colors.white,
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                child: Text(
                  'SAVED CREDIT CARDS',
                  style: AppTextStyles.body12w5,
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          if (isSelect) {
                            Navigator.pop(context, {
                              'name':
                                  '${viewModel.tariffsRepository.cardList[index].brand}  ****  ${viewModel.tariffsRepository.cardList[index].last4}',
                              'type': '2',
                              'id': viewModel.tariffsRepository.cardList[index].id.toString()
                            });
                          }
                        },
                        title: Text(
                          '${viewModel.tariffsRepository.cardList[index].brand}  ****  ${viewModel.tariffsRepository.cardList[index].last4}',
                          style: AppTextStyles.body16w5,
                        ),
                        leading: Icon(
                          Ionicons.card_outline,
                          size: 25,
                          color: AppColors.textColor.shade1,
                        ),
                        tileColor: Colors.white,
                        trailing: Icon(
                          Ionicons.chevron_forward_outline,
                          size: 20,
                          color: AppColors.textColor.shade2,
                        ),
                      ),
                  separatorBuilder: (context, index) => const SizedBox(height: 5),
                  itemCount: viewModel.tariffsRepository.cardList.length)
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                locator<LocalViewModel>().paymentRequestWithCardForm().then((paymentMethod) {
                  if (paymentMethod != null) {
                    viewModel.tariffsRepository.getClientSecretKey('Card${paymentMethod['last4']}').then((value) {
                      // if (viewModel.tariffsRepository.getState(tag) == 'success') {
                        locator<LocalViewModel>().confirmSetupIntent(paymentMethod['id'], value??'', tag).then((confi) {
                          isMain = true;
                          viewModel.notifyListeners();
                          if (confi!['success'] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(confi['err']),
                              backgroundColor: Colors.redAccent,
                            ));
                          }
                        }).catchError((err) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err.toString()),
                            backgroundColor: Colors.redAccent,
                          ));
                        });
                      // }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Unknown error'),
                      backgroundColor: Colors.redAccent,
                    ));
                  }
                }).catchError((err) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(err.toString()),
                    backgroundColor: Colors.redAccent,
                  ));
                });
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF1EC892), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Add new card',
                  style: AppTextStyles.body16w5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  PaymentViewModel viewModelBuilder(BuildContext context) {
    return PaymentViewModel(
      context: context,
      tariffsRepository: locator.get(),
      userRepository: locator.get(),
    );
  }
}
