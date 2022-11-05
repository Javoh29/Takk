import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/config/constants/constants.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/presentation/pages/fav_ordered_page/viewmodel/fav_ordered_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';

import '../../../components/back_to_button.dart';

// ignore: must_be_immutable
class FavOrderedPage extends ViewModelBuilderWidget<FavOrderedViewModel> {
  FavOrderedPage(this.model, this.isFav, {super.key});

  final CartResponse model;
  final bool isFav;

  @override
  void onViewModelReady(FavOrderedViewModel viewModel) {
    viewModel.initState();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, FavOrderedViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.cafeModel.name ?? '',
          style: TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        leading: BackToButton(
          title: 'Back',
          color: TextColor().shade1,
          onPressed: () {
            viewModel.pop();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.cafeInfoPage, arguments: {'cafeInfoModel': viewModel.cafeModel});
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(
                Ionicons.information_circle_outline,
                size: 25,
                color: AppColors.textColor,
              ))
        ],
        backgroundColor: AppColors.scaffoldColor,
        leadingWidth: 90,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (viewModel.cafeModel.deliveryAvailable ?? false)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: CupertinoSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text('Pick up', style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor)),
                  ),
                  1: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(
                        'Delivery',
                        style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor),
                      )),
                },
                groupValue: viewModel.selectTab,
                onValueChanged: (value) {
                  viewModel.selectTab = value as int;
                  viewModel.notifyListeners();
                },
              ),
            ),
          Container(
            height: 36,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              children: [
                TextButton(
                  onPressed: () {
                    viewModel.curTime = 5;
                    viewModel.notifyListeners();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          viewModel.curTime == 5 ? const Color(0xFF1EC892) : AppColors.textColor.shade3),
                      elevation: MaterialStateProperty.all(1.5),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12)),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                  child: Text(
                      'Quickest time: ${viewModel.selectTab == 0 ? 5 : viewModel.cafeModel.deliveryMinTime} min',
                      style: AppTextStyles.body16w5.copyWith(
                          color: viewModel.curTime == 5 ? AppColors.baseLight.shade100 : AppColors.textColor)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () {
                      viewModel.curTime = 15;
                      viewModel.notifyListeners();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            viewModel.curTime == 15 ? const Color(0xFF1EC892) : AppColors.textColor.shade3),
                        elevation: MaterialStateProperty.all(1.5),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12)),
                        shape:
                            MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                    child: Text('${viewModel.selectTab == 0 ? 15 : viewModel.cafeModel.deliveryMinTime! + 15} min',
                        style: AppTextStyles.body16w5.copyWith(
                            color: viewModel.curTime == 15 ? AppColors.baseLight.shade100 : AppColors.textColor)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showMaterialModalBottomSheet(
                        context: context,
                        expand: false,
                        builder: (context) {
                          var nowDate = DateTime.now();
                          var st = DateTime.parse(
                              '${DateFormat('yyyy-MM-dd').format(nowDate)} ${viewModel.cafeModel.openingTime}');
                          var en = DateTime.parse(
                              '${DateFormat('yyyy-MM-dd').format(nowDate)} ${viewModel.cafeModel.closingTime}');
                          if (en.hour <= st.hour) {
                            en = en.add(const Duration(days: 1));
                          }
                          en = en.add(const Duration(days: 1));
                          DateTime initDate;
                          if (st.isBefore(nowDate) && en.isAfter(nowDate)) {
                            initDate = DateTime(
                                nowDate.year, nowDate.month, nowDate.day, nowDate.hour, (nowDate.minute ~/ 10 * 10));
                            initDate = initDate.add(Duration(
                                minutes: viewModel.selectTab == 0 ? 15 : viewModel.cafeModel.deliveryMinTime!));
                          } else {
                            initDate = st.add(Duration(
                                days: 1,
                                minutes: viewModel.selectTab == 0 ? 15 : viewModel.cafeModel.deliveryMinTime!));
                          }
                          return SizedBox(
                            height: 320,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () => viewModel.pop(),
                                        child: Text('Cancel',
                                            style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor))),
                                    TextButton(
                                        onPressed: () => viewModel.pop(result: initDate),
                                        child:
                                            Text('Done', style: AppTextStyles.body15w5.copyWith(color: Colors.blue))),
                                  ],
                                ),
                                Expanded(
                                  child: CupertinoDatePicker(
                                      maximumDate: en,
                                      minuteInterval: 5,
                                      minimumDate: initDate,
                                      initialDateTime: initDate,
                                      onDateTimeChanged: (value) {
                                        initDate = value;
                                      }),
                                ),
                              ],
                            ),
                          );
                        }).then((value) {
                      if (value is DateTime) {
                        viewModel.costumTime = value;
                        viewModel.notifyListeners();
                      }
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          viewModel.curTime == 3 ? const Color(0xFF1EC892) : AppColors.textColor.shade3),
                      elevation: MaterialStateProperty.all(1.5),
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 12)),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                  child: Text(
                      viewModel.costumTime == null
                          ? 'Custom'
                          : '${viewModel.costumTime!.day == DateTime.now().day ? 'Today' : 'Tomorrow'} ${DateFormat().add_jm().format(viewModel.costumTime!)}',
                      style: AppTextStyles.body16w5
                          .copyWith(color: viewModel.curTime == 3 ? Colors.white : AppColors.textColor)),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text('${model.items[index].quantity}   x',
                        style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1)),
                    dense: true,
                    tileColor: Colors.white,
                    horizontalTitleGap: 0,
                    title: Text(viewModel.model.items[index].productName,
                        style: AppTextStyles.body15w6.copyWith(color: AppColors.textColor.shade1)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...viewModel.model.items[index].favModifiers!
                            .map((e) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${e.name}:'),
                                    Text('\$${e.price}'),
                                  ],
                                ))
                            .toList(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
                            ),
                            Text('\$${viewModel.model.items[index].totalPrice}',
                                style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 1,
                    ),
                itemCount: viewModel.model.items.length),
          ),
          GestureDetector(
            onTap: () {
              Future.delayed(
                Duration.zero,
                () async {
                  double t = 0;
                  if (viewModel.costumTime != null) {
                    t = viewModel.costumTime!.millisecondsSinceEpoch / 1000;
                  } else {
                    t = DateTime.now().add(Duration(minutes: viewModel.curTime)).millisecondsSinceEpoch / 1000;
                  }
                  await viewModel.checkTimestampFunc(viewModel.cafeModel.id!, t.toInt());
                  if (viewModel.isSuccess(tag: viewModel.tagCheckTimestampFunc)) {
                    if (viewModel.favOrderedRepository.isAviable) {
                      await viewModel.addToCartFunc(viewModel.model.id, isFav);

                      if (viewModel.isSuccess(tag: viewModel.tagaddToCartFunc)) {
                        viewModel.navigateTo(Routes.orderedPage, arg: {
                          'curTime': viewModel.curTime,
                          'costumTime': viewModel.costumTime,
                          'isPickUp': viewModel.selectTab == 0
                        }).then((value) {
                          if (value != null) {
                            Future.delayed(
                              Duration.zero,
                              () => viewModel.navigateTo(
                                Routes.confirmPage,
                                arg: {
                                  'data': jsonDecode(value.toString()),
                                },
                              ),
                            );
                          }
                        });
                      }
                    } else {
                      viewModel.pop();
                    }
                  } else {
                    viewModel.pop();
                  }
                },
              );
            },
            child: Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.getPrimaryColor(99)),
                    child: Text(viewModel.model.items.length.toString(),
                        style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100)),
                  ),
                  Expanded(
                      child: Center(
                    child: Text('Proceed', style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100)),
                  )),
                  Container(
                    height: 35,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.getPrimaryColor(99)),
                    child: Text('\$${numFormat.format(viewModel.model.subTotalPrice)}',
                        style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  FavOrderedViewModel viewModelBuilder(BuildContext context) {
    return FavOrderedViewModel(context: context, model: model, cafeRepository: locator.get());
  }
}
