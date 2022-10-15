import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/favorites/view_model/favorites_viewmodel.dart';
import '../../../../config/constants/constants.dart';
import '../../../widgets/cache_image.dart';

class FavoritesPage extends ViewModelBuilderWidget<FavoritesViewModel> {
  FavoritesPage({super.key});
  final String tag = 'FavoritesPage';
  final String cartTag = 'Clearcart';

  @override
  void onViewModelReady(FavoritesViewModel viewModel) {
    super.onViewModelReady(viewModel);
     viewModel.clearCart(cartTag);
  }

  @override
  Widget builder(
    BuildContext context,
    FavoritesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Favorites',
            style: AppTextStyles.body16w5,
          ),
          leading: TextButton.icon(
            onPressed: () {},
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
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(
                Ionicons.information_circle_outline,
                size: 25,
                color: AppColors.textColor.shade1,
              ),
            )
          ],
          backgroundColor: AppColors.scaffoldColor,
          leadingWidth: 90,
          elevation: 0,
          centerTitle: true,
        ),
        body: viewModel.isSuccess(tag: cartTag)
            ? Stack(
                children: [
                  ListView.builder(
                    itemCount: locator<LocalViewModel>().favList.length,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 60),
                    itemBuilder: (context, index) => _item(
                        context, locator<LocalViewModel>().favList[index]),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 15,
                    right: 15,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.accentColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text('Create',
                          style: AppTextStyles.body16w5
                              .copyWith(color: AppColors.white)),
                    ),
                  )
                ],
              )
            : const SizedBox.shrink());
  }

  Widget _item(BuildContext context, CartResponse model) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                model.name ?? '',
                style: AppTextStyles.body16w5,
              ),
              subtitle: Text(
                model.cafe!.name ?? '',
                style: AppTextStyles.body16w5
                    .copyWith(color: AppColors.textColor.shade2),
              ),
              leading: CacheImage(
                model.cafe!.logoSmall ?? '',
                fit: BoxFit.cover,
                height: 50,
                width: 50,
                borderRadius: 25,
                placeholder: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Icon(
                    Ionicons.fast_food_outline,
                    size: 30,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              children: model.items
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.productName,
                                style: AppTextStyles.body14w6,
                              ),
                              Text(
                                '\$${e.totalPrice}',
                                style: AppTextStyles.body14w6,
                              ),
                            ],
                          ),
                          if (e.favModifiers!.isNotEmpty)
                            ...e.favModifiers!
                                .map(
                                  (m) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        m.name ?? '',
                                        style: AppTextStyles.body13w5.copyWith(
                                            color: AppColors.textColor.shade2),
                                      ),
                                      Text(
                                        '\$${m.price}',
                                        style: AppTextStyles.body13w5.copyWith(
                                            color: AppColors.textColor.shade2),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          if (e.instruction.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Instruction:',
                                  style: AppTextStyles.body13w5.copyWith(
                                      color: AppColors.textColor.shade2),
                                ),
                                Text(
                                  e.instruction,
                                  style: AppTextStyles.body13w5.copyWith(
                                      color: AppColors.textColor.shade2),
                                ),
                              ],
                            ),
                          Divider(
                            color: AppColors.textColor.shade2,
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total price',
                  style: AppTextStyles.body14w6,
                ),
                Text(
                  '\$${numFormat.format(model.subTotalPrice)}',
                  style: AppTextStyles.body14w6,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'Edit',
                      style: AppTextStyles.body14w5
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.accentColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      'Order',
                      style: AppTextStyles.body14w5
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  FavoritesViewModel viewModelBuilder(BuildContext context) {
    return FavoritesViewModel(context: context, favoriteRepo: locator.get());
  }
}