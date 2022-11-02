import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/order_info/viewmodel/order_info_page_viewmodel.dart';
import 'package:takk/presentation/widgets/order_info_widget.dart';
import 'package:takk/presentation/widgets/order_info_item_widget.dart';
import '../../../../data/models/emp_order_model.dart';
import '../../../widgets/cache_image.dart';

class OrderInfoPage extends ViewModelBuilderWidget<OrderInfoPageViewModel> {
  OrderInfoPage({
    required this.orderModel,
    required this.type,
    super.key,
  });
  final EmpOrderModel orderModel;
  final int type;

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
          orderModel.cafe!.name ?? '',
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
              )),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => viewModel.refreshFunc(orderModel.id),
            key: viewModel.refresh,
            child: ListView(
              children: [
                ListTile(
                  leading: CacheImage(
                    orderModel.user!.avatar ?? '',
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
                    orderModel.user!.username ?? '',
                    style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
                  ),
                  subtitle: Text(
                    'Order id: ${orderModel.id}',
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                  trailing: SizedBox(
                    height: 40,
                    width: 40,
                    child: IconButton(
                        onPressed: () {
                          // launch('tel:+${orderModel.user!.phone}');
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
                    'Order time: ${DateFormat('MMM dd, yyyy - ').add_jm().format(DateTime.fromMillisecondsSinceEpoch(orderModel.created ?? 0))}',
                    style: AppTextStyles.body14w5.copyWith(
                      color: AppColors.textColor.shade1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                  child: Text(
                    'Pickup time: ${DateFormat('MMM dd, yyyy - ').add_jm().format(DateTime.fromMillisecondsSinceEpoch(orderModel.preOrderTimestamp ?? 0))}',
                    style: AppTextStyles.body14w5.copyWith(
                      color: AppColors.textColor.shade1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                  child: CupertinoSlidingSegmentedControl(
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
                      viewModel.selectTab = value as int;
                      viewModel.notifyListeners();
                    },
                  ),
                ),
                viewModel.selectTab == 0 && orderModel.kitchen!.isNotEmpty
                    ? CheckboxListTile(
                        title: Text(
                          'Select all',
                          style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1),
                        ),
                        value: viewModel.isSelectAllZero,
                        onChanged: (value) async {
                          List<int> l = [];
                          for (var element in orderModel.kitchen!) {
                            element.isReady = value;
                            l.add(element.id ?? 0);
                          }
                          viewModel.isSelectAllZero = value ?? false;

                          await viewModel.setChangeStateEmpOrderFunc(l, viewModel.selectTab == 0);
                          if (viewModel.isError(tag: viewModel.tagSetChangeState)) {
                            for (var element in orderModel.kitchen!) {
                              element.isReady = !value!;
                            }
                            viewModel.isSelectAllZero = !value!;
                            viewModel.notifyListeners();
                          }
                        },
                        tileColor: Colors.white,
                        dense: true,
                      )
                    : viewModel.selectTab == 1 && orderModel.main!.isNotEmpty
                        ? CheckboxListTile(
                            title: Text(
                              'Select all',
                              style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade1),
                            ),
                            value: viewModel.isSelectAllFirst,
                            onChanged: (value) async {
                              List<int> l = [];
                              for (var element in orderModel.main!) {
                                element.isReady = value;
                                l.add(element.id ?? 0);
                              }
                              viewModel.isSelectAllFirst = value ?? false;

                              await viewModel.setChangeStateEmpOrderFunc(l, viewModel.selectTab == 0);
                              if (viewModel.isError(tag: viewModel.tagSetChangeState)) {
                                for (var element in orderModel.kitchen!) {
                                  element.isReady = !value!;
                                }
                                viewModel.isSelectAllFirst = !value!;
                                viewModel.notifyListeners();
                              }
                            },
                            tileColor: Colors.white,
                            dense: true,
                          )
                        : const Center(
                            child: Text("null"),
                          ),
                Divider(
                  height: 1,
                  color: AppColors.textColor.shade2,
                ),
                if (viewModel.selectTab == 0)
                  ...orderModel.kitchen!
                      .map(
                        (e) => OrderItemWidget(empOrderModel: orderModel, isKitchen: true, item: e, type: type, viewModel: viewModel,),
                      )
                      .toList()
                else
                ...orderModel.main!
                    .map(
                      (e) => OrderItemWidget(empOrderModel: orderModel, isKitchen: false, item: e, type: type, viewModel: viewModel),
                    )
                    .toList(),
                OrderInfoWidget(),
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
              // child: OrderInfoBtnsWidget(empOrderModel: orderModel, type: type),
              child: _btns(context, viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btns(BuildContext context, OrderInfoPageViewModel viewModel) {
    if (type == 3) {
      return SizedBox(
        child: TextButton(
            onPressed: () {
              // List<Items> list = [];
              // list.addAll(orderModel.kitchen!);
              // list.addAll(orderModel.main!);
              // Navigator.pushNamed(context, Routes.refundOrderPage,
              //     arguments: {'orderId': orderModel.id, 'items': list, 'total': orderModel.totalPrice});
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
            child: Text(
              'Refund',
              style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
            )),
      );
    } else if (type == 4) {
      return SizedBox(
        child: TextButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent[700]),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
            child: Text(
              'Acknowledge',
              style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
            )),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextButton(
                  onPressed: () {
                    // List<Items> list = [];
                    // list.addAll(orderModel.kitchen!);
                    // list.addAll(orderModel.main!);
                    // Navigator.pushNamed(context, Routes.refundOrderPage,
                    //     arguments: {'orderId': orderModel.id, 'items': list, 'total': orderModel.totalPrice});
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'Refund',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextButton(
                  onPressed: () {
                    bool isReady = true;
                    for (var element in orderModel.kitchen!) {
                      if (!element.isReady!) {
                        isReady = false;
                      }
                    }
                    for (var element in orderModel.main!) {
                      if (!element.isReady!) {
                        isReady = false;
                      }
                    }
                    if (isReady) {
                      Future.delayed(Duration.zero, () async {
                        await viewModel.changeStateOrderFunc(orderModel.id ?? 0);
                        if (viewModel.isSuccess(tag: viewModel.tagChangeStatusOrder)) {
                          viewModel.pop();
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select products that are ready'),
                        backgroundColor: Colors.orangeAccent,
                      ));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.accentColor),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  child: Text(
                    'Ready',
                    style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                  )),
            ),
          ),
        ],
      );
    }
  }

  @override
  OrderInfoPageViewModel viewModelBuilder(BuildContext context) {
    return OrderInfoPageViewModel(context: context, orderModel: orderModel);
  }
}
