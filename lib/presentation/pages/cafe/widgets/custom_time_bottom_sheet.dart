import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/presentation/pages/cafe/viewmodel/cafe_viewmodel.dart';

import '../../../../core/di/app_locator.dart';

// ignore: must_be_immutable
class CustomTimeBottomSheet extends ViewModelBuilderWidget<CafeViewModel> {
  CustomTimeBottomSheet({required this.cafeModel, super.key});
  CafeModel cafeModel;

  @override
  Widget builder(BuildContext context, CafeViewModel viewModel, Widget? child) {
    DateTime nowDate;
    if (cafeModel.isOpenNow ?? false) {
      nowDate = DateTime.now();
    } else {
      nowDate = DateTime.now().add(const Duration(days: 1));
    }
    var st = DateTime.parse('${DateFormat('yyyy-MM-dd').format(nowDate)} ${cafeModel.openingTime}');
    var en = DateTime.parse('${DateFormat('yyyy-MM-dd').format(nowDate)} ${cafeModel.closingTime}');
    if (en.hour <= st.hour) {
      en = en.add(const Duration(days: 1));
    }
    // en = en.add(Duration(days: 1));
    DateTime initDate;
    if (st.isBefore(nowDate) && en.isAfter(nowDate)) {
      initDate = DateTime(nowDate.year, nowDate.month, nowDate.day, nowDate.hour, (nowDate.minute ~/ 10 * 10));
      initDate = initDate.add(Duration(minutes: viewModel.selectTab == 0 ? 15 : cafeModel.deliveryMinTime!));
    } else {
      initDate = DateTime(nowDate.year, nowDate.month, nowDate.day, nowDate.hour, (nowDate.minute ~/ 10 * 10));
      initDate = st.add(Duration(days: 1, minutes: viewModel.selectTab == 0 ? 15 : cafeModel.deliveryMinTime!));
    }
    return SizedBox(
      height: 330,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.body15w5,
                  )),
              TextButton(
                  onPressed: () => Navigator.pop(context, initDate),
                  child: Text(
                    'Done',
                    style: AppTextStyles.body15w5.copyWith(color: Colors.blue),
                  )),
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
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  CafeViewModel viewModelBuilder(BuildContext context) {
    return CafeViewModel(context: context, cafeRepository: locator.get());
  }
}
