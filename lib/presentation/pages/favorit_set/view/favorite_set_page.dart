import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';
import 'package:takk/presentation/pages/cart/viewmodel/cart_viewmodel.dart';
import 'package:takk/presentation/pages/latest_order/viewmodel/lates_orders_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../widgets/error_dialog.dart';

class FavoriteSetPage extends ViewModelBuilderWidget<CafeViewModel> {
  FavoriteSetPage({super.key});

  final String tag = 'FavoriteSetPage';

  final String tagCreate = 'tagCreate';

  final TextEditingController _textEditingController = TextEditingController();

  CafeModel? _cafeModel;

  String titleText = '';

  @override
  Widget builder(BuildContext context, CafeViewModel viewModel, Widget? child) {
    if (viewModel.isError(tag: tag)) {
      Future.delayed(
        Duration.zero,
        () => showErrorDialog(context, 'error', true).then(
          (value) {
            if (value is bool) locator<CartViewModel>().getCartListFunc();
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a set',
          style: AppTextStyles.body16w5.copyWith(letterSpacing: .5),
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
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
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Row(
                children: [
                  Text(
                    'Title:',
                    style: AppTextStyles.body16w5,
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      style: AppTextStyles.body16w5,
                      cursorColor: AppColors.textColor.shade1,
                      controller: _textEditingController,
                      onChanged: (value) => titleText = value,
                    ),
                  )
                ],
              ),
              Divider(
                color: AppColors.textColor.shade1,
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: ListTile(
                  onTap: () {
                    // Navigator.pushNamed(context, Routes.pickCafePage)
                    //     .then((value) {
                    //   if (value is CafeModel) {
                    //     _cafeModel = value;
                    //     model.stateUpdate();
                    //   }
                    // });
                  },
                  leading: Icon(
                    Ionicons.cafe_outline,
                    size: 25,
                    color: AppColors.textColor.shade1,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select cafe',
                        style: AppTextStyles.body16w5,
                      ),
                      if (_cafeModel != null)
                        Flexible(
                          child: Text(
                            _cafeModel!.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body14w5,
                          ),
                        )
                    ],
                  ),
                  horizontalTitleGap: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  trailing: Icon(
                    Ionicons.chevron_forward_outline,
                    size: 20,
                    color: AppColors.textColor.shade1,
                  ),
                  tileColor: Colors.white,
                ),
              ),
              ListTile(
                onTap: () {
                  viewModel.navigateTo(Routes.cafePage,
                      arg: {'cafe_model': _cafeModel, 'isFavorite': true}).then((value) {
                        if (value is bool) {
                        locator<CartViewModel>().getCartListFunc();
                      }
                      });
                  
                },
                leading: Icon(
                  Ionicons.add_circle_outline,
                  size: 25,
                  color: _cafeModel != null
                      ? AppColors.textColor.shade1
                      : AppColors.textColor.shade3,
                ),
                title: Text(
                  'Add product',
                  style: AppTextStyles.body16w5.copyWith(
                    color: _cafeModel != null
                        ? AppColors.textColor.shade1
                        : AppColors.textColor.shade3,
                  ),
                ),
                horizontalTitleGap: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                trailing: Icon(
                  Ionicons.chevron_forward_outline,
                  size: 20,
                  color: _cafeModel != null
                      ? AppColors.textColor.shade1
                      : AppColors.textColor.shade3,
                ),
                tileColor: Colors.white,
              ),
              if (locator<CartRepository>().cartResponse.items.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: true,
                          minLeadingWidth: 20,
                          leading: Text(
                            '${locator<CartRepository>().cartResponse.items[index].quantity} x ',
                            style: AppTextStyles.body15w6,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                locator<CartRepository>()
                                    .cartResponse
                                    .items[index]
                                    .productName,
                                style: AppTextStyles.body14w6,
                              ),
                              Text(
                                '\$${locator<CartRepository>().cartResponse.items[index].productPrice}',
                                style: AppTextStyles.body14w6,
                              )
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              ...locator<CartRepository>()
                                  .cartResponse
                                  .items[index]
                                  .productModifiers
                                  .map((e) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.name ?? '',
                                            style: AppTextStyles.body14w5
                                                .copyWith(
                                                    color: AppColors
                                                        .getPrimaryColor(90)),
                                          ),
                                          Text(
                                            '\$${e.price}',
                                            style: AppTextStyles.body14w5
                                                .copyWith(
                                                    color: AppColors
                                                        .getPrimaryColor(90)),
                                          )
                                        ],
                                      ))
                                  .toList(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Instruction:',
                                    style: AppTextStyles.body14w5.copyWith(
                                        color: AppColors.getPrimaryColor(90)),
                                  ),
                                  Text(
                                    locator<CartRepository>()
                                        .cartResponse
                                        .items[index]
                                        .instruction,
                                    style: AppTextStyles.body14w5.copyWith(
                                        color: AppColors.getPrimaryColor(90)),
                                  )
                                ],
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            height: 20,
                            width: 20,
                            child: IconButton(
                              onPressed: () {
                                locator<CartViewModel>().delCartItemFunc(
                                    locator<CartRepository>()
                                        .cartResponse
                                        .items[index]
                                        .id);
                              },
                              splashRadius: 20,
                              icon: Icon(
                                Ionicons.trash_outline,
                                size: 16,
                                color: AppColors.textColor.shade1,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              height: 1,
                              color: AppColors.textColor.shade2,
                            ),
                          ),
                      itemCount:
                          locator<CartRepository>().cartResponse.items.length),
                ),
              if (locator<CartRepository>().cartResponse.items.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total price:',
                        style: AppTextStyles.body14w5,
                      ),
                      Text(
                        '\$${locator<CartRepository>().cartResponse.totalPrice}',
                        style: AppTextStyles.body14w5,
                      )
                    ],
                  ),
                )
            ],
          ),
          if (!viewModel.isBusy(tag: tag) || !viewModel.isBusy(tag: tagCreate))
            Center(
                child: CircularProgressIndicator(
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
            )),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: TextButton(
              onPressed: () {
                if (locator<CartRepository>().cartList.isNotEmpty &&
                    titleText.isNotEmpty) {
                  locator<LatestOrdersViewModel>().setCartFov(titleText);
                } else if (locator<CartRepository>().cartList.isNotEmpty &&
                    titleText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter title'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.accentColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: Text(
                'Create',
                style: AppTextStyles.body16w5,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  CafeViewModel viewModelBuilder(BuildContext context) {
    return CafeViewModel(cafeRepository: locator.get(), context: context);
  }
}
