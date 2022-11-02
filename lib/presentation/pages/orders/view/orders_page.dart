import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/orders/viewmodel/orders_page_viewmodel.dart';
import 'package:takk/presentation/widgets/orders_page_item_widget.dart';

class OrdersPage extends ViewModelBuilderWidget<OrdersPageViewModel> {
  ValueNotifier<List<int>> alarm = ValueNotifier([]);
  @override
  Widget builder(BuildContext context, OrdersPageViewModel viewModel, Widget? child) {
    if (viewModel.isNewOrder) {
      List<int> list = [];
      viewModel.ordersRepository.listNewOrders.forEach((element) {
        if (!element.isAcknowledge!) {
          list.add(element.id ?? 0);
        }
      });
      alarm.value = list;
      viewModel.isNewOrder = false;
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: AppTextStyles.body18w5.copyWith(color: AppColors.baseLight.shade100),
          ),
          bottom: TabBar(
            controller: viewModel.tabController,
            tabs: const [
              Tab(text: 'New'),
              Tab(text: 'Ready'),
              Tab(text: 'Refund'),
            ],
            labelStyle: AppTextStyles.body15w6.copyWith(color: AppColors.baseLight.shade100),
          ),
          leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: Colors.white,
            ),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text(
              'Back',
              style: AppTextStyles.body16w5.copyWith(color: AppColors.baseLight.shade100),
            ),
          ),
          backgroundColor: AppColors.primaryLight,
          leadingWidth: 90,
          centerTitle: true,
        ),
        body: TabBarView(
          controller: viewModel.tabController,
          children: [
            RefreshIndicator(
              key: viewModel.refNew,
              onRefresh: () => viewModel.getNewOrders(),
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      OrdersPageItemWidget(model: viewModel.ordersRepository.listNewOrders[index], type: 1),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: viewModel.ordersRepository.listNewOrders.length),
            ),
            // Center(
            //   child: Text(
            //     'Orders not found',
            //     style: kTextStyle(
            //         color: textColor2, size: 16, fontWeight: FontWeight.w500),
            //   ),
            // ),
            RefreshIndicator(
              key: viewModel.refReady,
              onRefresh: () => viewModel.getReadyOrders(),
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  itemBuilder: (context, index) =>
                      OrdersPageItemWidget(model: viewModel.ordersRepository.listReadyOrders[index], type: 3),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: viewModel.ordersRepository.listReadyOrders.length),
            ),
            RefreshIndicator(
              key: viewModel.refRefund,
              onRefresh: () => viewModel.getRefundOrders(),
              child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  itemBuilder: (context, index) =>
                      OrdersPageItemWidget(model: viewModel.ordersRepository.listRefundOrders[index], type: 4),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: viewModel.ordersRepository.listRefundOrders.length),
            ),
          ],
        ),
      ),
    );
  }

  @override
  OrdersPageViewModel viewModelBuilder(BuildContext context) {
    return OrdersPageViewModel(context: context);
  }
}
