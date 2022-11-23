import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';

import '../pages/orders/viewmodel/orders_page_viewmodel.dart';

Future<T?> showAlarmDialog<T>(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) {
      return ViewModelBuilder<OrdersPageViewModel>.reactive(
          viewModelBuilder: () => OrdersPageViewModel(context: context, ordersRepository: locator.get()),
          builder: (context, viewModel, child) {
            return Dialog(
              backgroundColor: AppColors.primaryLight.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              insetPadding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Ionicons.cart,
                    size: 50,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 10),
                    child: Text(
                      'Reminder.',
                      style: AppTextStyles.body20wB.copyWith(color: AppColors.baseLight.shade100),
                    ),
                  ),
                  Text(
                    'You have new order. Please, acknowledge it.',
                    style: AppTextStyles.body16w5.copyWith(color: AppColors.baseLight.shade100),
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    child: viewModel.isBusy()
                        ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              viewModel.setEmpAckFunc(locator<LocalViewModel>().alarm.value.first, isAlarm: true);
                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                            child: Text(
                              'OK',
                              style: AppTextStyles.body16w5.copyWith(color: AppColors.primaryLight.shade100),
                            ),
                          ),
                  )
                ],
              ),
            );
          });
    },
  );
}
