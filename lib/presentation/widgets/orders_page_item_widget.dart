import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/presentation/pages/orders/viewmodel/orders_page_viewmodel.dart';

import '../routes/routes.dart';
import 'cache_image.dart';

class OrdersPageItemWidget extends ViewModelWidget<OrdersPageViewModel> {
  OrdersPageItemWidget({super.key, required this.type, required this.model, required this.refreshIndicatorCallBack});

  int type;
  EmpOrderModel model;
  final Function() refreshIndicatorCallBack;

  @override
  Widget build(BuildContext context, OrdersPageViewModel viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.baseLight.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0xffEEEEEE), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.cafe!.name ?? '',
            style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1),
          ),
          ListTile(
            leading: CacheImage(model.user!.avatar ?? '',
                fit: BoxFit.cover,
                height: 50,
                width: 50,
                borderRadius: 25,
                placeholder: Image.asset(
                  'assets/icons/ic_user.png',
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                )),
            title: Text(
              model.user!.username ?? 'Unknown',
              style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
            ),
            subtitle: Text(
              'Order id: ${model.id}',
              style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (model.isKitchen ?? false)
                  Text(
                    'Kitchen',
                    style: AppTextStyles.body15w6.copyWith(color: AppColors.warningColor),
                  ),
                if (model.main!.isNotEmpty)
                  Text(
                    '${model.isKitchen ?? false ? '& ' : ''}Bar',
                    style: AppTextStyles.body15w6.copyWith(color: AppColors.warningColor),
                  ),
              ],
            ),
            contentPadding: EdgeInsets.zero,
          ),
          Text(
              'Order time: ${DateFormat('MMM dd, yyyy - (').add_jm().format(DateTime.fromMillisecondsSinceEpoch(model.created ?? 0))})'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
                'Pickup time: ${DateFormat('MMM dd, yyyy - (').add_jm().format(DateTime.fromMillisecondsSinceEpoch(model.preOrderTimestamp ?? 0))})'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total price:',
                style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
              ),
              Text(
                '\$${model.totalPrice}',
                style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
              )
            ],
          ),
          if (type == 4)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Refund amount:',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.red),
                  ),
                  Text(
                    '\$${model.refundAmount}',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.red),
                  )
                ],
              ),
            ),
          Divider(
            height: 20,
            color: AppColors.textColor.shade2,
          ),
          Row(
            children: [
              if (type == 1 && !model.isAcknowledge!)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SizedBox(
                      height: 45,
                      child: TextButton(
                        onPressed: () async {
                          await viewModel.setEmpAckFunc(model.id ?? -1);
                          if (viewModel.isSuccess(tag: viewModel.tagSetEmpAckFunc)) {
                            viewModel.isNewOrder = true;
                            model.isAcknowledge = true;
                            viewModel.notifyListeners();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blueAccent[700]),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                        child: Text(
                          'Acknowledge',
                          style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      if (!viewModel.isBusy(tag: viewModel.tag)) {
                        viewModel.navigateTo(Routes.orderInfoPage,
                            arg: {'model': model, 'type': type}).then((value) => refreshIndicatorCallBack);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.secondaryGreen,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'View order',
                      style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
