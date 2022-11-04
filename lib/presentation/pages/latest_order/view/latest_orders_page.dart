import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/domain/repositories/latest_orders_repository.dart';
import 'package:takk/presentation/pages/latest_order/viewmodel/lates_orders_viewmodel.dart';
import 'package:takk/presentation/widgets/latest_orders_item.dart';

import '../../../components/back_to_button.dart';

class LatestOrdersPage extends ViewModelBuilderWidget<LatestOrdersViewModel> {
  final String tag = 'LatestOrdersPage';
  ScrollController scrollController = ScrollController();

  @override
  void onViewModelReady(LatestOrdersViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getUserOrder(tag);
  }

  @override
  Widget builder(
      BuildContext context, LatestOrdersViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Orders',
            style: AppTextStyles.body16w5.copyWith(letterSpacing: 0.5)),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: BackToButton(
          title: 'Back',
          color: TextColor().shade1,
          onPressed: () {
            viewModel.pop();
          },
        ),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: viewModel.isSuccess(tag: tag)
          ? ListView.separated(
              controller: scrollController,
              itemCount: locator<LatestOrdersRepository>().ordersList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              separatorBuilder: (_, i) => const SizedBox(height: 15),
              itemBuilder: (context, index) => LatestOrdersItem(
                  modelCart:
                      locator<LatestOrdersRepository>().ordersList[index],
                  viewModel: viewModel))
          : const SizedBox.shrink(),
    );
  }

  @override
  LatestOrdersViewModel viewModelBuilder(BuildContext context) {
    return LatestOrdersViewModel(
        context: context, latestOrdersRepository: locator.get());
  }

  @override
  void onDestroy(LatestOrdersViewModel model) {
    scrollController.dispose();
  }
}
