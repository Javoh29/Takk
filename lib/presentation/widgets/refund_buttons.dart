import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/presentation/pages/order_info_page/viewmodel/order_info_page_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/app_text_styles.dart';
import '../../data/models/emp_order_model.dart';

class RefundButtons extends ViewModelWidget<OrderInfoPageViewModel> {
  const RefundButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, OrderInfoPageViewModel viewModel) {
    if (viewModel.type == 3) {
      return SizedBox(
        child: TextButton(
            onPressed: () {
              List<Items> list = [];
              list.addAll(viewModel.orderModel.kitchen!);
              list.addAll(viewModel.orderModel.main!);
              Navigator.pushNamed(context, Routes.refundOrderPage, arguments: {
                'orderId': viewModel.orderModel.id,
                'items': list,
                'total': viewModel.orderModel.totalPrice
              });
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
            child: Text(
              'Refund',
              style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
            )),
      );
    } else if (viewModel.type == 4) {
      return SizedBox(
        child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent[700]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
            child: Text(
              'Acknowledge',
              style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
            )),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextButton(
                  onPressed: () {
                    List<Items> list = [];
                    list.addAll(viewModel.orderModel.kitchen!);
                    list.addAll(viewModel.orderModel.main!);
                    Navigator.pushNamed(context, Routes.refundOrderPage, arguments: {
                      'orderId': viewModel.orderModel.id,
                      'items': list,
                      'total': viewModel.orderModel.totalPrice
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'Refund',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextButton(
                  onPressed: () {
                    bool isReady = true;
                    for (var element in viewModel.orderModel.kitchen!) {
                      if (!element.isReady!) {
                        isReady = false;
                      }
                    }
                    for (var element in viewModel.orderModel.main!) {
                      if (!element.isReady!) {
                        isReady = false;
                      }
                    }
                    if (isReady) {
                      Future.delayed(Duration.zero, () async {
                        await viewModel.changeStateOrderFunc(viewModel.orderModel.id ?? 0);
                        if (viewModel.isSuccess(tag: viewModel.tagChangeStatusOrder)) {
                          viewModel.pop();
                        }
                      });
                    } else {
                      showTopSnackBar(
                          context,
                          const CustomSnackBar.info(
                            message: 'Please select products that are ready',
                            backgroundColor: Colors.orangeAccent,
                          ));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.accentColor),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'Ready',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                  )),
            ),
          ),
        ],
      );
    }
  }
}
