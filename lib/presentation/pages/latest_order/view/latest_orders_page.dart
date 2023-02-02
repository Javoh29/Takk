import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/latest_order/viewmodel/lates_orders_viewmodel.dart';
import 'package:takk/presentation/widgets/latest_orders_item.dart';

import '../../../components/back_to_button.dart';

// ignore: must_be_immutable
class LatestOrdersPage extends ViewModelBuilderWidget<LatestOrdersViewModel> {
  final String tag = 'LatestOrdersPage';
  final String tagRef = 'LatestOrdersPageRef';
  ScrollController scrollController = ScrollController();
  DateTime initDate = DateTime.now();
  final GlobalKey<RefreshIndicatorState> refState = GlobalKey<RefreshIndicatorState>();

  LatestOrdersPage({super.key});

  @override
  void onViewModelReady(LatestOrdersViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getUserOrder(tag);
  }

  @override
  Widget builder(BuildContext context, LatestOrdersViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Orders', style: AppTextStyles.body16w5.copyWith(letterSpacing: 0.5)),
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
      body: RefreshIndicator(
        key: refState,
        onRefresh: () => viewModel.getUserOrder(tagRef),
        child: ListView.separated(
          controller: scrollController,
          itemCount: viewModel.latestOrdersRepository.ordersList.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          separatorBuilder: (_, i) => LatestOrdersItem(modelCart: viewModel.latestOrdersRepository.ordersList[i]),
          itemBuilder: (context, i) {
            final date =
                DateTime.fromMillisecondsSinceEpoch(viewModel.latestOrdersRepository.ordersList[i].preOrderTimestamp!);
            if (i == 0) {
              initDate = date;
              return titleWeek(date);
            } else {
              if (initDate.difference(date).inDays > 7) {
                initDate = date;
                return titleWeek(date);
              }
            }
            return const SizedBox(height: 15);
          },
        ),
      ),
    );
  }

  Widget titleWeek(DateTime date) {
    final nextDate = date.add(const Duration(days: 7));
    String title = '';
    if (date.month == nextDate.month) {
      title = DateFormat('MMM dd-${nextDate.day}, yyyy').format(date);
    } else {
      final str = DateFormat('MMM dd-').format(date);
      title = str + DateFormat('dd, yyyy').format(nextDate);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: AppTextStyles.body18w6,
      ),
    );
  }

  @override
  LatestOrdersViewModel viewModelBuilder(BuildContext context) {
    return LatestOrdersViewModel(context: context, latestOrdersRepository: locator.get());
  }

  @override
  void onDestroy(LatestOrdersViewModel model) {
    scrollController.dispose();
  }
}
