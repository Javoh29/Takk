import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/order_info/viewmodel/order_info_page_viewmodel.dart';

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
    viewModel.initState(orderModel);
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
            onPressed: () => Navigator.pop(context),
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
            onRefresh: () => viewModel.refreshFunc(orderModel.id, context),
            key: viewModel.refresh,
            child: ListView(
              children: [
                ListTile(
                  leading: CacheImage(orderModel.user!.avatar ?? '',
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                      borderRadius: 25,
                      placeholder: Image.asset(
                        'assets/icons/ic_user.png',
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      )),
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
                        onChanged: (value) {
                          List<int> l = [];
                          for (var element in orderModel.kitchen!) {
                            element.isReady = value;
                            l.add(element.id ?? 0);
                          }
                          viewModel.isSelectAllZero = value ?? false;

                          // model.setChangeStateEmpOrder(tag, l, _selectTab == 0).then((m) {
                          //   if (model.getState(tag) != 'success') {
                          //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //       content: Text(m),
                          //       backgroundColor: Colors.redAccent,
                          //     ));
                          //     setState(() {
                          //       orderModel.kitchen!.forEach((element) {
                          //         element.isReady = !value!;
                          //       });
                          //       _isSelectAll_0 = !value!;
                          //     });
                          //   }
                          // });
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
                            value: viewModel.isSelectAllFIrst,
                            onChanged: (value) {
                              List<int> l = [];
                              for (var element in orderModel.main!) {
                                element.isReady = value;
                                l.add(element.id ?? 0);
                              }
                              viewModel.isSelectAllFIrst = value ?? false;
                              viewModel.notifyListeners();

                              // model.setChangeStateEmpOrder(tag, l, _selectTab == 0).then((m) {
                              //   if (model.getState(tag) != 'success') {
                              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //       content: Text(m),
                              //       backgroundColor: Colors.redAccent,
                              //     ));
                              //     setState(() {
                              //       orderModel.main!.forEach((element) {
                              //         element.isReady = !value!;
                              //       });
                              //       _isSelectAll_1 = !value!;
                              //     });
                              //   }
                              // });
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
                // if (viewModel.selectTab == 0)
                //   ...orderModel.kitchen!.map((e) => _item(e, true)).toList()
                // else
                //   ...orderModel.main!.map((e) => _item(e, false)).toList(),
                // _infoWidget()
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
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: AppColors.textColor.shade3, offset: const Offset(-2, 0), blurRadius: 10),
                ],
              ),
              // child: _btns(),
            ),
          )
        ],
      ),
    );
  }

  @override
  OrderInfoPageViewModel viewModelBuilder(BuildContext context) {
    // TODO: implement viewModelBuilder
    throw UnimplementedError();
  }
}
