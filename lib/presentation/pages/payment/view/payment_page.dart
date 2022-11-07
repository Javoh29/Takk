import 'dart:io';

import '../../../../commons.dart';
import '../../../components/back_to_button.dart';
import '../../../widgets/info_dialog.dart';
import '../viewmodel/payment_viewmodel.dart';

// ignore: must_be_immutable
class PaymentPage extends ViewModelBuilderWidget<PaymentViewModel> {
  PaymentPage({super.key, required this.isSelect});
  final bool isSelect;
  String tag = 'PaymentPageOld';

  @override
  void onViewModelReady(PaymentViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getUserCards();
  }

  @override
  Widget builder(BuildContext context, PaymentViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment methods', style: AppTextStyles.body16w5),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: BackToButton(
          title: 'Back',
          color: TextColor().shade1,
          onPressed: () {
            viewModel.pop();
          },
        ),
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
                    viewModel.pop(result: {'name': 'Cafe budget', 'type': '0'});
                  } else {
                    viewModel.navigateTo(Routes.tariffsPage).then((value) {
                      if (value is bool) {
                        viewModel.getUserData();
                      }
                    });
                  }
                },
                title: Row(
                  children: [
                    Text(
                      '\$${viewModel.userRepository.userModel!.balance}',
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
                tileColor: AppColors.baseLight.shade100,
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
                    viewModel.getIsGooglePay();
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
                  tileColor: AppColors.baseLight.shade100,
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
                            viewModel.pop(result: {
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
                        tileColor: AppColors.baseLight.shade100,
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
                viewModel.paymentRequestWithCardForm();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.secondaryGreen, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  'Add new card',
                  style: AppTextStyles.body16w5.copyWith(color: AppColors.baseLight.shade100),
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
