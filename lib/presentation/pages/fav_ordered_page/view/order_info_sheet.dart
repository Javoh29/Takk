import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';

import '../../../widgets/cache_image.dart';
import '../viewmodel/order_info_sheet_viewmodel.dart';

// ignore: must_be_immutable
class OrderInfoSheet extends ViewModelBuilderWidget<OrderInfoSheetViewModel> {
  OrderInfoSheet({required this.id, super.key});

  int id;

  @override
  void onViewModelReady(viewModel) {
    viewModel.getOrderInfoViewModel(id);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, OrderInfoSheetViewModel viewModel, Widget? child) {
    return SizedBox(
      height: 400,
      child: viewModel.isSuccess(tag: viewModel.tag)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    viewModel.orderInfoSheetRepository.cartResponses!.cafe!.name ?? '',
                    style: AppTextStyles.body14w5.copyWith(
                      color: AppColors.textColor.shade1,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Status: ',
                        style: AppTextStyles.body14w5.copyWith(
                          color: AppColors.textColor.shade2,
                        ),
                      ),
                      Text(
                        viewModel.orderInfoSheetRepository.cartResponses!.status ?? 'unknown',
                        style: AppTextStyles.body16w6.copyWith(color: AppColors.accentColor),
                      )
                    ],
                  ),
                  leading: CacheImage(
                    viewModel.orderInfoSheetRepository.cartResponses!.cafe!.logoSmall ?? '',
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                    borderRadius: 20,
                    placeholder: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Ionicons.fast_food_outline,
                        size: 30,
                        color: AppColors.primaryLight.shade100,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Ionicons.close,
                      color: AppColors.textColor.shade1,
                      size: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    '${viewModel.orderInfoSheetRepository.cartResponses!.delivery!.address != null ? 'Delivery time' : 'Pickup time'}: ${DateFormat('MMM dd, yyyy - (').add_jm().format(DateTime.fromMillisecondsSinceEpoch(viewModel.orderInfoSheetRepository.cartResponses!.preOrderTimestamp ?? 0))})',
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                  ),
                ),
                Divider(
                  height: 1,
                  color: AppColors.textColor.shade3,
                  endIndent: 15,
                  indent: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Text(
                    'Order ID: #${viewModel.orderInfoSheetRepository.cartResponses!.id}',
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                  ),
                ),
                ...viewModel.orderInfoSheetRepository.cartResponses!.items
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              Divider(
                                height: 1,
                                color: AppColors.textColor.shade3,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.productName,
                                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                                  ),
                                  Text(
                                    '\$${e.productPrice}',
                                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                Divider(
                  height: 1,
                  endIndent: 15,
                  indent: 15,
                  color: AppColors.textColor.shade3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                      Text(
                        '\$${viewModel.orderInfoSheetRepository.cartResponses!.taxTotal}',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  endIndent: 15,
                  indent: 15,
                  color: AppColors.textColor.shade3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tip',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                      Text(
                        '\$${viewModel.orderInfoSheetRepository.cartResponses!.tip}',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  endIndent: 15,
                  indent: 15,
                  color: AppColors.textColor.shade3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery fee',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                      Text(
                        '\$${viewModel.orderInfoSheetRepository.cartResponses!.deliveryPrice}',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 15,
                  endIndent: 15,
                  color: AppColors.textColor.shade3,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.body14w6.copyWith(color: AppColors.textColor.shade1)),
                      Text(
                        '\$${viewModel.orderInfoSheetRepository.cartResponses!.totalPrice}',
                        style: AppTextStyles.body14w6.copyWith(color: AppColors.textColor.shade1),
                      )
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  OrderInfoSheetViewModel viewModelBuilder(BuildContext context) {
    return OrderInfoSheetViewModel(context: context, orderInfoSheetRepository: locator.get());
  }
}
