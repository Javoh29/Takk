import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/cart/viewmodel/cart_viewmodel.dart';

import '../../../routes/routes.dart';

// ignore: must_be_immutable
class CartPage extends ViewModelBuilderWidget<CartViewModel> {
  CartPage({
    super.key,
    required this.curTime,
    required this.costumTime,
    required this.isPickUp,
  });

  final int curTime;
  final DateTime? costumTime;
  final bool isPickUp;

  @override
  Widget builder(BuildContext context, CartViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
        ),
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text(
              'Back',
              style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
            )),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       highlightColor: Colors.transparent,
        //       splashColor: Colors.transparent,
        //       icon: Icon(
        //         Icons.favorite_border_outlined,
        //         size: 25,
        //         color: textColor2,
        //       ))
        // ],
        backgroundColor: AppColors.scaffoldColor,
        leadingWidth: 90,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: viewModel.getCartListFunc(),
        builder: (_, snap) {
          if (viewModel.isSuccess(tag: viewModel.tagGetCartListFunc)) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(
                                '${viewModel.cartRepository.cartResponse.items[index].quantity}   x',
                                style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1),
                              ),
                              dense: true,
                              tileColor: Colors.white,
                              horizontalTitleGap: 0,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.cartRepository.cartResponse.items[index].productName,
                                    style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1),
                                  ),
                                  Text(
                                    '\$${viewModel.cartRepository.cartResponse.items[index].productPrice}',
                                    style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ...viewModel.cartRepository.cartResponse.items[index].productModifiers
                                      .map((e) => Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                e.name ?? '',
                                                style: AppTextStyles.body14w5.copyWith(
                                                  color: AppColors.getPrimaryColor(99),
                                                ),
                                              ),
                                              Text(
                                                '\$${e.price}',
                                                style: AppTextStyles.body14w5.copyWith(
                                                  color: AppColors.getPrimaryColor(99),
                                                ),
                                              )
                                            ],
                                          ))
                                      .toList(),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 25,
                                height: 25,
                                child: IconButton(
                                  onPressed: () async {
                                    await viewModel
                                        .delCartItemFunc(viewModel.cartRepository.cartResponse.items[index].id);
                                  },
                                  splashRadius: 25,
                                  icon: Icon(
                                    Ionicons.trash_outline,
                                    size: 20,
                                    color: AppColors.textColor.shade1,
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 1,
                              ),
                          itemCount: viewModel.cartRepository.cartResponse.items.length),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Color(0xffeaeaea), blurRadius: 20, offset: Offset(0, -2))]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1),
                              ),
                              Text(
                                '\$${viewModel.numFormat.format(viewModel.cartRepository.cartResponse.subTotalPrice)}',
                                style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              height: 1,
                              color: AppColors.textColor.shade2,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                if (viewModel.cartRepository.cartList.isNotEmpty) {
                                  viewModel.navigateTo(Routes.orderedPage, arg: {
                                    'curTime': curTime,
                                    'costumTime': costumTime,
                                    'isPickUp': isPickUp
                                  }).then((value) {
                                    viewModel.notifyListeners();
                                    if (value != null) {
                                      Future.delayed(
                                        Duration.zero,
                                        () => viewModel.navigateTo(Routes.confirmPage,
                                            arg: {'data': jsonDecode(value.toString())}).then(
                                          (value) => viewModel.pop(),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  backgroundColor: MaterialStateProperty.all(Color(0xFF1EC892))),
                              child: Text(
                                'Go to Checkout',
                                style: AppTextStyles.body15w6.copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  CartViewModel viewModelBuilder(BuildContext context) {
    return CartViewModel(context: context, cartRepository: locator.get());
  }
}
