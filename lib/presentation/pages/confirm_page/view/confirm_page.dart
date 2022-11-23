import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/confirm_page/viewmodel/confirm_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';

// ignore: must_be_immutable
class ConfirmPage extends ViewModelBuilderWidget<ConfirmPageViewModel> {
  ConfirmPage(this.data, {super.key});
  Map<String, dynamic> data;
  @override
  Widget builder(BuildContext context, ConfirmPageViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leadingWidth: 60,
        centerTitle: true,
        title: Text('CONFIRMATION', style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Ionicons.close,
            size: 22,
            color: AppColors.textColor.shade1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(top: 30, bottom: 20),
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(50)),
            child: const Icon(
              Ionicons.checkmark,
              size: 30,
              color: AppColors.accentColor,
            ),
          ),
          Text('Your order has been placed successfully.',
              style: AppTextStyles.body15w6.copyWith(color: AppColors.accentColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              'You will be notified, when your order is ready.',
              style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade2),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                Text(
                  'Order ID #${data['order']}\n${DateFormat('MMM dd, yyyy - ').add_jm().format(DateTime.fromMillisecondsSinceEpoch(data['order_created_at'] ?? 0))}',
                  style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1, height: 2),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 15,
                  color: AppColors.textColor.shade2,
                  thickness: 0.2,
                ),
                Text(
                  'Pickup time:\n${DateFormat('MMM dd, yyyy - ').add_jm().format(DateTime.fromMillisecondsSinceEpoch(data['pickup_time'] ?? 0))}',
                  style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1, height: 2),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 15,
                  color: AppColors.textColor.shade2,
                  thickness: 0.2,
                ),
                //Link Cafe Budget
                if (data['payment_type'] == 'budget')
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'You could have earned \$${data['cashback']} back if you paid with ',
                          style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade2)),
                      TextSpan(
                          text: 'Cafe Budget.',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(context, Routes.tariffsPage),
                          style: AppTextStyles.body15w6.copyWith(color: AppColors.accentColor))
                    ]),
                  )
                else
                  Text(
                    'CashBack:\nYou have earned \$${data['cashback']} back with this order.',
                    style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1, height: 2),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  ConfirmPageViewModel viewModelBuilder(BuildContext context) {
    return ConfirmPageViewModel(context: context);
  }
}
