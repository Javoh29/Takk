import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';

import '../../../../config/constants/constants.dart';
import '../../../../core/di/app_locator.dart';
import '../../../routes/routes.dart';
import '../../../widgets/loading_dialog.dart';
import '../../cafe/widgets/add_gds_sheet.dart';
import '../viewmodel/favorite_edit_viewmodel.dart';

// ignore: must_be_immutable
class FavoriteEditPage extends ViewModelBuilderWidget<FavoriteEditViewModel> {
  FavoriteEditPage({super.key, required this.id, required this.title});

  late final TextEditingController _textEditingController =
      TextEditingController(text: title);
  final int id;
  final String title;

  String titleText = '';

  final String tag = 'FavoriteEditPage';

  CafeModel? _cafeModel;

  @override
  void onViewModelReady(FavoriteEditViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.addToCart(tag, id, true);
  }

  @override
  void onDestroy(FavoriteEditViewModel model) {
    _textEditingController.dispose();
    super.onDestroy(model);
  }

  @override
  Widget builder(
      BuildContext context, FavoriteEditViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit', style: AppTextStyles.body16w5),
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
        actions: [
          IconButton(
            // delete button
            onPressed: () {
              viewModel.deleteFavorite(tag, id).then((value) {
                viewModel.pop();
              });
            },
            icon: Icon(
              Ionicons.trash_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
          )
        ],
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: viewModel.isBusy(tag: tag)
          ? const SizedBox.shrink()
          : Builder(builder: (context) {
              _cafeModel ??= CafeModel(
                  id: viewModel.cartRepository.cartResponse.cafe!.id,
                  name: viewModel.cartRepository.cartResponse.cafe!.name);
              return Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Row(
                        children: [
                          Text(
                            'Title:',
                            style: AppTextStyles.body16w6,
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              style: AppTextStyles.body16w5
                                  .copyWith(color: AppColors.textColor.shade1),
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
                          onTap: () {},
                          leading: Icon(
                            Ionicons.cafe_outline,
                            size: 25,
                            color: AppColors.textColor.shade1,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cafe',
                                style: AppTextStyles.body16w5,
                              ),
                              Flexible(
                                child: Text(
                                  _cafeModel?.name ?? 'Undefined',
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
                          if (_cafeModel != null) {
                            viewModel.navigateTo(Routes.cafePage, arg: {
                              'cafe_model': _cafeModel,
                              'isFav': true
                            }).then((value) {
                              if (value is bool) {
                                viewModel.getCartList(tag);
                              }
                            });
                          }
                        },
                        leading: Icon(
                          Ionicons.add_circle_outline,
                          size: 25,
                          color: AppColors.textColor.shade1,
                        ),
                        title: Text(
                          'Add product',
                          style: AppTextStyles.body16w5,
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
                      if (viewModel
                          .cartRepository.cartResponse.items.isNotEmpty)
                        Container(
                          width: double.infinity,
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
                                  onTap: () {
                                    showCupertinoModalBottomSheet(
                                        context: context,
                                        expand: true,
                                        builder: (context) => AddGdsSheet(
                                            cafeId: viewModel.cartRepository
                                                    .cartResponse.cafe?.id ??
                                                0,
                                            productModel: null,
                                            cartModel: viewModel.cartRepository
                                                .cartResponse.items[index]));
                                  },
                                  dense: true,
                                  minLeadingWidth: 20,
                                  leading: Text(
                                    '${viewModel.cartRepository.cartResponse.items[index].quantity} x ',
                                    style: AppTextStyles.body15w6,
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        viewModel.cartRepository.cartResponse
                                            .items[index].productName,
                                        style: AppTextStyles.body14w6,
                                      ),
                                      Text(
                                        '\$${viewModel.cartRepository.cartResponse.items[index].productPrice}',
                                        style: AppTextStyles.body14w6,
                                      )
                                    ],
                                  ),
                                  subtitle: Column(
                                    children: [
                                      ...viewModel.cartRepository.cartResponse
                                          .items[index].favModifiers!
                                          .map(
                                        (e) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              e.name ?? "undefined",
                                              style: AppTextStyles.body14w5
                                                  .copyWith(
                                                      color: AppColors
                                                          .primaryLight
                                                          .shade100),
                                            ),
                                            Text(
                                              '\$${e.price}',
                                              style: AppTextStyles.body14w5
                                                  .copyWith(
                                                      color: AppColors
                                                          .primaryLight
                                                          .shade100),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Instruction:',
                                            style: AppTextStyles.body14w5
                                                .copyWith(
                                                    color: AppColors
                                                        .primaryLight.shade100),
                                          ),
                                          Text(
                                            viewModel
                                                .cartRepository
                                                .cartResponse
                                                .items[index]
                                                .instruction,
                                            style: AppTextStyles.body14w5
                                                .copyWith(
                                                    color: AppColors
                                                        .primaryLight.shade100),
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
                                        viewModel.delCartItem(
                                            tag,
                                            viewModel.cartRepository
                                                .cartResponse.items[index].id);
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Divider(
                                      height: 1,
                                      color: AppColors.textColor.shade2,
                                    ),
                                  ),
                              itemCount: viewModel
                                  .cartRepository.cartResponse.items.length),
                        ),
                      if (viewModel
                          .cartRepository.cartResponse.items.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total price:',
                                style: AppTextStyles.body14w5,
                              ),
                              Text(
                                '\$${numFormat.format(viewModel.cartRepository.cartResponse.subTotalPrice)}',
                                style: AppTextStyles.body14w5,
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    left: 15,
                    right: 15,
                    child: SizedBox(
                      height: 45,
                      child: TextButton(
                          onPressed: () {
                            if (viewModel.cartRepository.cartResponse.items
                                    .isNotEmpty &&
                                _textEditingController.text.isNotEmpty) {
                              viewModel.setCartFov(
                                  tag, _textEditingController.text,
                                  favID: id);
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColors.accentColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)))),
                          child: Text(
                            'Save',
                            style: AppTextStyles.body16w5
                                .copyWith(color: AppColors.baseLight.shade100),
                          )),
                    ),
                  )
                ],
              );
            }),
    );
  }

  @override
  FavoriteEditViewModel viewModelBuilder(BuildContext context) {
    return FavoriteEditViewModel(
        context: context, favoriteRepository: locator.get());
  }
}
