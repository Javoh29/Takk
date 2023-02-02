import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import 'item_ctg.dart';

// ignore: must_be_immutable
class CustomSliverAppBar extends ViewModelWidget<CafeViewModel> {
  CustomSliverAppBar({
    Key? key,
    required this.cafeModel,
    required this.isFavotrite,
    required this.isSearch,
    required this.autoScrollController,
  }) : super(key: key);

  final CafeModel cafeModel;
  final bool isFavotrite;
  DateTime? _custumTime;
  final bool isSearch;
  AutoScrollController autoScrollController;

  @override
  Widget build(BuildContext context, CafeViewModel viewModel) {
    _custumTime = viewModel.custumTime;
    final int selectTab = viewModel.selectTab;

    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.scaffoldColor,
      leading: const SizedBox.shrink(),
      flexibleSpace: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: const Icon(
                  Ionicons.search_outline,
                  size: 20,
                  color: Color(0xff818185),
                ),
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'Search',
                hintStyle: AppTextStyles.body14w4
                    .copyWith(color: const Color(0xff818185)),
              ),
              onChanged: (value) {
                viewModel.filter(value);
              },
            ),
          ),
          if (cafeModel.deliveryAvailable == true &&
              !isFavotrite &&
              !locator<LocalViewModel>().isCashier)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 15),
              child: CupertinoSlidingSegmentedControl(
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      'Pick up',
                      style: AppTextStyles.body14w6,
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Text(
                      'Delivery',
                      style: AppTextStyles.body14w6,
                    ),
                  )
                },
                groupValue: selectTab,
                onValueChanged: (value) {
                  viewModel.funcSegmentControlChange(value, cafeModel);
                },
              ),
            ),
          if (!locator<LocalViewModel>().isCashier && !isFavotrite)
            Container(
              height: 32,
              margin: const EdgeInsets.symmetric(vertical: 14),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  List<String> texts = [
                    cafeModel.isOpenNow!
                        ? 'Quickest time: ${selectTab == 0 ? 5 : cafeModel.deliveryMinTime} min'
                        : '${DateFormat().add_jm().format(
                              DateTime.parse(
                                      '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${cafeModel.openingTime ?? '00:00'}')
                                  .add(
                                Duration(
                                    days: 1,
                                    minutes: selectTab == 0
                                        ? 5
                                        : cafeModel.deliveryMinTime!),
                              ),
                            )} (Tomorrow)',
                    cafeModel.isOpenNow!
                        ? '${selectTab == 0 ? 15 : cafeModel.deliveryMinTime! + 10} min'
                        : '${DateFormat().add_jm().format(
                              DateTime.parse(
                                      '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${cafeModel.openingTime ?? '00:00'}')
                                  .add(
                                Duration(
                                    days: 1,
                                    minutes: selectTab == 0
                                        ? 15
                                        : cafeModel.deliveryMinTime! + 10),
                              ),
                            )} (Tomorrow)',
                    _custumTime == null
                        ? 'Custom'
                        : '${DateFormat().add_jm().format(_custumTime!)} (${_custumTime!.day == DateTime.now().day ? 'Today' : 'Tomorrow'})',
                  ];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: TextButton(
                      onPressed: () {
                        viewModel.funcTextButtons(index, cafeModel, context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          viewModel.selectTimeIndex == index
                              ? const Color(0xFF1EC892)
                              : AppColors.textColor.shade3,
                        ),
                        elevation: MaterialStateProperty.all(1.5),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text(
                        texts[index],
                        style: AppTextStyles.body14w5.copyWith(
                            color: viewModel.selectTimeIndex == index
                                ? Colors.white
                                : AppColors.textColor.shade1),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const SizedBox(height: 15),
          if (!isSearch)
            SizedBox(
              height: 80,
              width: double.infinity,
              child: ListView.separated(
                itemCount: locator<LocalViewModel>().headCtgList.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) => ItemCtg(
                    model: locator<LocalViewModel>().headCtgList[index],
                    viewModel: viewModel,
                    autoScrollController: autoScrollController),
              ),
            ),
        ],
      ),
      elevation: 0,
      collapsedHeight: isSearch
          ? 95
          : !locator<LocalViewModel>().isCashier && !isFavotrite
              ? cafeModel.deliveryAvailable ?? false
                  ? 230
                  : 180
              : 145,
    );
  }
}
