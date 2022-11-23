import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/widgets/order_info_widget.dart';
import 'package:takk/presentation/widgets/order_info_item_widget.dart';
import 'package:takk/presentation/widgets/refund_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/emp_order_model.dart';
import '../../../widgets/cache_image.dart';
import '../viewmodel/order_info_page_viewmodel.dart';

// ignore: must_be_immutable
class OrderInfoPage extends ViewModelBuilderWidget<OrderInfoPageViewModel> {
  OrderInfoPage({
    required this.eModel,
    required this.eType,
    super.key,
  });

  final EmpOrderModel eModel;
  final int eType;

  @override
  void onViewModelReady(viewModel) {
    viewModel.initState();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, OrderInfoPageViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.orderModel.cafe!.name ?? '',
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body16w5.copyWith(
            letterSpacing: 0.5,
            color: AppColors.textColor.shade1,
          ),
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leadingWidth: 30,
        leading: IconButton(
            onPressed: () => viewModel.pop(),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            )),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.local_print_shop,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => viewModel.refreshFunc(viewModel.orderModel.id),
            key: viewModel.refresh,
            child: ListView(
              children: [
                ListTile(
                  leading: CacheImage(
                    viewModel.orderModel.user!.avatar ?? '',
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                    borderRadius: 25,
                    placeholder: Image.asset(
                      'assets/icons/ic_user.png',
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                  ),
                  title: Text(
                    viewModel.orderModel.user!.username ?? '',
                    style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
                  ),
                  subtitle: Text(
                    'Order id: ${viewModel.orderModel.id}',
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                  trailing: SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse('tel:+${viewModel.orderModel.user!.phone}'));
                        },
                        icon: Icon(
                          Icons.call,
                          size: 22,
                          color: AppColors.textColor.shade1,
                        )),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    'Order time: ${DateFormat('MMM dd, yyyy - ').add_jm().format(DateTime.fromMillisecondsSinceEpoch(viewModel.orderModel.created ?? 0))}',
                    style: AppTextStyles.body14w5.copyWith(
                      color: AppColors.textColor.shade1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                  child: Text(
                    'Pickup time: ${DateFormat('MMM dd, yyyy - ').add_jm().format(DateTime.fromMillisecondsSinceEpoch(viewModel.orderModel.preOrderTimestamp ?? 0))}',
                    style: AppTextStyles.body14w5.copyWith(
                      color: AppColors.textColor.shade1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  child: CupertinoSlidingSegmentedControl<int>(
                    children: {
                      0: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Text(
                          'Kitchen',
                          style: AppTextStyles.body14w6.copyWith(
                            color: AppColors.textColor.shade1,
                          ),
                        ),
                      ),
                      1: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Text(
                          'Bar',
                          style: AppTextStyles.body14w6.copyWith(
                            color: AppColors.textColor.shade1,
                          ),
                        ),
                      )
                    },
                    groupValue: viewModel.selectTab,
                    onValueChanged: (value) {
                      viewModel.selectTab = value ?? 0;
                      viewModel.notifyListeners();
                    },
                  ),
                ),
                viewModel.selectTab == 0 && viewModel.orderModel.kitchen!.isNotEmpty
                    ? CheckboxListTile(
                        title: Text(
                          'Select all',
                          style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1),
                        ),
                        value: viewModel.isSelectAllZero,
                        onChanged: (value) => viewModel.tapSelectAll(value),
                        tileColor: Colors.white,
                        dense: true,
                      )
                    : viewModel.selectTab == 1 && viewModel.orderModel.main!.isNotEmpty
                        ? CheckboxListTile(
                            title: Text(
                              'Select all',
                              style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1),
                            ),
                            value: viewModel.isSelectAllFirst,
                            onChanged: (value) => viewModel.tapSelectAll(value),
                            tileColor: Colors.white,
                            dense: true,
                          )
                        : const SizedBox.shrink(),
                Divider(
                  height: 1,
                  color: AppColors.textColor.shade2,
                ),
                if (viewModel.selectTab == 0)
                  ...viewModel.orderModel.kitchen!
                      .map(
                        (e) => OrderItemWidget(
                          empOrderModel: viewModel.orderModel,
                          isKitchen: true,
                          item: e,
                          type: viewModel.type,
                          viewModel: viewModel,
                        ),
                      )
                      .toList(),
                if (viewModel.selectTab == 1)
                  ...viewModel.orderModel.main!
                      .map(
                        (e) => OrderItemWidget(
                            empOrderModel: viewModel.orderModel,
                            isKitchen: false,
                            item: e,
                            type: viewModel.type,
                            viewModel: viewModel),
                      )
                      .toList(),
                if (viewModel.selectTab == 0 && viewModel.orderModel.kitchen!.isNotEmpty) OrderInfoWidget(),
                if (viewModel.selectTab == 1 && viewModel.orderModel.main!.isNotEmpty) OrderInfoWidget(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.baseLight.shade100,
                boxShadow: [
                  BoxShadow(color: AppColors.textColor.shade3, offset: const Offset(-2, 0), blurRadius: 10),
                ],
              ),
              child: const RefundButtons(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  OrderInfoPageViewModel viewModelBuilder(BuildContext context) {
    return OrderInfoPageViewModel(
        context: context, orderModel: eModel, orderInfoRepository: locator.get(), type: eType);
  }
}
