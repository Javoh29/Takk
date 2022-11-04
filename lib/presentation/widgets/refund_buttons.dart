import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/presentation/pages/order_info_page/viewmodel/order_info_page_viewmodel.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/app_text_styles.dart';

class RefundButtons extends ViewModelWidget<OrderInfoPageViewModel> {
  const RefundButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, OrderInfoPageViewModel viewModel) {
    if (viewModel.type == 3) {
      return SizedBox(
        child: TextButton(
            onPressed: () {
              // List<Items> list = [];
              // list.addAll(orderModel.kitchen!);
              // list.addAll(orderModel.main!);
              // Navigator.pushNamed(context, Routes.refundOrderPage,
              //     arguments: {'orderId': orderModel.id, 'items': list, 'total': orderModel.totalPrice});
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            child: Text(
              'Refund',
              style: AppTextStyles.body16w6
                  .copyWith(color: AppColors.textColor.shade1),
            )),
      );
    } else if (viewModel.type == 4) {
      return SizedBox(
        child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(Colors.blueAccent[700]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            child: Text(
              'Acknowledge',
              style: AppTextStyles.body16w6
                  .copyWith(color: AppColors.textColor.shade1),
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
                    // List<Items> list = [];
                    // list.addAll(orderModel.kitchen!);
                    // list.addAll(orderModel.main!);
                    // Navigator.pushNamed(context, Routes.refundOrderPage,
                    //     arguments: {'orderId': orderModel.id, 'items': list, 'total': orderModel.totalPrice});
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.redAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'Refund',
                    style: AppTextStyles.body16w6
                        .copyWith(color: AppColors.textColor.shade1),
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
                        await viewModel
                            .changeStateOrderFunc(viewModel.orderModel.id ?? 0);
                        if (viewModel.isSuccess(
                            tag: viewModel.tagChangeStatusOrder)) {
                          viewModel.pop();
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select products that are ready'),
                        backgroundColor: Colors.orangeAccent,
                      ));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(AppColors.accentColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'Ready',
                    style: AppTextStyles.body16w6
                        .copyWith(color: AppColors.textColor.shade1),
                  )),
            ),
          ),
        ],
      );
    }
  }

}