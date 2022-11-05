import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';
import 'package:takk/presentation/pages/cafe/widgets/cafe_products_item.dart';
import 'package:takk/presentation/pages/cafe/widgets/gds_item.dart';
import '../../../../config/constants/constants.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_sliver_app_bar.dart';

// ignore: must_be_immutable
class CafePage extends ViewModelBuilderWidget<CafeViewModel> {
  CafePage({
    required this.cafeModel,
    required this.isFavotrite,
    super.key,
  });

  final CafeModel cafeModel;
  final bool isFavotrite;
  final String tag = 'CafePage';
  final String cartTag = 'CafePage';

  final AutoScrollController _autoScrollController = AutoScrollController(axis: Axis.vertical);
  bool isLoad = true;
  int selectTab = 0;

  @override
  void onViewModelReady(CafeViewModel viewModel) {
    super.onViewModelReady(viewModel);
    selectTab = viewModel.selectTab;
    viewModel.curTime = selectTab == 0 ? 5 : cafeModel.deliveryMinTime!;
    viewModel.getCafeProductList(tag, cafeModel.id!);
  }

  @override
  Widget builder(BuildContext context, CafeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: CustomAppBar(cafeModel: cafeModel, isFavorite: isFavotrite),
      body: Builder(
        builder: (context) {
          if (viewModel.isSuccess(tag: tag)) {
            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: _autoScrollController,
                  slivers: [
                    CustomSliverAppBar(
                      cafeModel: cafeModel,
                      isFavotrite: isFavotrite,
                      selectTab: selectTab,
                      isSearch: viewModel.isSearch,
                      autoScrollController: _autoScrollController,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        viewModel.isSearch
                            ? viewModel.listSearchProducts.map(
                                (e) {
                                  return GestureDetector(
                                    onTap: () {
                                      viewModel.cafeProductItemFunction(
                                        isFavorite: isFavotrite,
                                        available: e.available,
                                        context: context,
                                        cafeModel: cafeModel,
                                        productModel: e,
                                      );
                                    },
                                    child: !locator<LocalViewModel>().isCashier && !isFavotrite && (e.available)
                                        ? Stack(
                                            children: [
                                              GdsItem(e: e),
                                              Container(
                                                height: 85,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.symmetric(vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white70,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                    e.available
                                                        ? 'The product is available from ${e.start.substring(0, 5)} to ${e.end.substring(0, 5)}'
                                                        : 'The product is not available',
                                                    style: AppTextStyles.body13w5,
                                                    textAlign: TextAlign.center),
                                              )
                                            ],
                                          )
                                        : GdsItem(e: e),
                                  );
                                },
                              ).toList()
                            : [
                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: viewModel.cafeProducts.length,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  separatorBuilder: (context, index) => const SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) => CafeProductsItem(
                                    data: viewModel.cafeProducts[index],
                                    index: index,
                                    isFavotrite: isFavotrite,
                                    autoScrollController: _autoScrollController,
                                    cafeModel: cafeModel,
                                  ),
                                )
                              ],
                      ),
                    ),
                  ],
                ),
                if (locator<CartRepository>().cartList.isNotEmpty && !isFavotrite)
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.cartListFunction(tag: tag, cafeModel: cafeModel, context: context);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.getPrimaryColor(90),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.getPrimaryColor(99),
                              ),
                              child: Text(
                                locator<CartRepository>().cartList.length.toString(),
                                style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Proceed',
                                  style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), color: AppColors.getPrimaryColor(99)),
                              child: Text(
                                '\$${numFormat.format(locator<CartRepository>().cartResponse.subTotalPrice)}',
                                style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
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
  CafeViewModel viewModelBuilder(BuildContext context) {
    return CafeViewModel(context: context, cafeRepository: locator.get());
  }
}
