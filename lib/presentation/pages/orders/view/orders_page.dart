import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/components/back_to_button.dart';
import 'package:takk/presentation/pages/orders/viewmodel/orders_page_viewmodel.dart';
import 'package:takk/presentation/widgets/orders_page_item_widget.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  ValueNotifier<List<int>> alarm = ValueNotifier([]);

  late TabController tabController;
  final GlobalKey<RefreshIndicatorState> refNew =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refReady =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> refRefund =
      GlobalKey<RefreshIndicatorState>();

  late var update;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    Future.delayed(
        const Duration(milliseconds: 400), () => refNew.currentState!.show());
    tabController.addListener(() {
      switch (tabController.index) {
        case 0:
          Future.delayed(const Duration(milliseconds: 200),
              () => refNew.currentState!.show());
          break;
        case 1:
          Future.delayed(const Duration(milliseconds: 200),
              () => refReady.currentState!.show());
          break;
        case 2:
          // TODO bu 3 edi
          Future.delayed(const Duration(milliseconds: 200),
              () => refRefund.currentState!.show());
          break;
      }
      update = () {
        Future.delayed(Duration.zero, () => refNew.currentState!.show());
      };
      locator<LocalViewModel>().notifier.addListener(update);
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrdersPageViewModel>.reactive(
        viewModelBuilder: () => OrdersPageViewModel(
            context: context, ordersRepository: locator.get()),
        builder: (context, viewModel, child) {
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
                  style: AppTextStyles.body18w5
                      .copyWith(color: AppColors.baseLight.shade100),
                ),
                bottom: TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(text: 'New'),
                    Tab(text: 'Ready'),
                    Tab(text: 'Refund'),
                  ],
                  labelStyle:
                      AppTextStyles.body15w6.copyWith(color: AppColors.white),
                ),
                leading: BackToButton(
                  title: 'Back',
                  onPressed: () {
                    viewModel.pop();
                  },
                ),
                backgroundColor: AppColors.primaryLight.shade100,
                leadingWidth: 90,
                centerTitle: true,
              ),
              body: TabBarView(
                controller: tabController,
                children: [
                  RefreshIndicator(
                    key: refNew,
                    onRefresh: () => viewModel.getNewOrders(),
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) => OrdersPageItemWidget(
                              model: viewModel
                                  .ordersRepository.listNewOrders[index],
                              type: 1,
                              refreshIndicatorCallBack: () {
                                Future.delayed(
                                    const Duration(milliseconds: 400),
                                    () => refNew.currentState!.show());
                              },
                            ),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount:
                            viewModel.ordersRepository.listNewOrders.length),
                  ),
                  // Center(
                  //   child: Text(
                  //     'Orders not found',
                  //     style: kTextStyle(
                  //         color: textColor2, size: 16, fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  RefreshIndicator(
                    key: refReady,
                    onRefresh: () => viewModel.getReadyOrders(),
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        itemBuilder: (context, index) => OrdersPageItemWidget(
                            model: viewModel
                                .ordersRepository.listReadyOrders[index],
                            type: 3,
                            refreshIndicatorCallBack: () {
                              Future.delayed(const Duration(milliseconds: 400),
                                  () => refReady.currentState!.show());
                            }),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount:
                            viewModel.ordersRepository.listReadyOrders.length),
                  ),
                  RefreshIndicator(
                    key: refRefund,
                    onRefresh: () => viewModel.getRefundOrders(),
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        itemBuilder: (context, index) => OrdersPageItemWidget(
                            model: viewModel
                                .ordersRepository.listRefundOrders[index],
                            type: 4,
                            refreshIndicatorCallBack: () {
                              Future.delayed(const Duration(milliseconds: 400),
                                  () => refRefund.currentState!.show());
                            }),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount:
                            viewModel.ordersRepository.listRefundOrders.length),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
