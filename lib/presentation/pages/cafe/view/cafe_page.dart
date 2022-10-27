import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';
import 'package:takk/presentation/pages/cafe/widgets/cafe_products_item.dart';
import 'package:takk/presentation/pages/cafe/widgets/gds_item.dart';
import '../../../../config/constants/constants.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/models/product_model.dart';
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

  final AutoScrollController _autoScrollController =
      AutoScrollController(axis: Axis.vertical);
  List<ProductModel> searchList = [];
  bool isLoad = true;
  bool isSearch = false;
  DateTime? _costumTime;
  int selectTab = 0;
  late int curTime = selectTab == 0 ? 5 : cafeModel.deliveryMinTime!;

  @override
  void onViewModelReady(CafeViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getCafeProductList(tag, cafeModel.id!);
    viewModel.getCartList(cartTag);
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
                        costumTime: _costumTime,
                        isSearch: isSearch),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        isSearch
                            ? searchList.map(
                                (e) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: !locator<LocalViewModel>()
                                                .isCashier &&
                                            !isFavotrite &&
                                            (e.available)
                                        ? Stack(
                                            children: [
                                              GdsItem(e: e),
                                              Container(
                                                height: 85,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white70,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Text(
                                                    e.available
                                                        ? 'The product is available from ${e.start.substring(0, 5)} to ${e.end.substring(0, 5)}'
                                                        : 'The product is not available',
                                                    style:
                                                        AppTextStyles.body13w5,
                                                    textAlign:
                                                        TextAlign.center),
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
                                  itemCount: locator<LocalViewModel>()
                                      .cafeProducts
                                      .length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) =>
                                      CafeProductsItem(
                                    data: locator<LocalViewModel>()
                                        .cafeProducts[index],
                                    index: index,
                                    isFavotrite: isFavotrite,
                                    autoScrollController: _autoScrollController,
                                  ),
                                )
                              ],
                      ),
                    ),
                  ],
                ),
                if (locator<LocalViewModel>().cartList.isNotEmpty)
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {},
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
                                locator<LocalViewModel>()
                                    .cartList
                                    .length
                                    .toString(),
                                style: AppTextStyles.body16w6,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Proceed',
                                  style: AppTextStyles.body16w6,
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.getPrimaryColor(99)),
                              child: Text(
                                '\$${numFormat.format(locator<LocalViewModel>().cartResponse.subTotalPrice)}',
                                style: AppTextStyles.body16w6,
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
    return CafeViewModel(context: context);
  }
}
