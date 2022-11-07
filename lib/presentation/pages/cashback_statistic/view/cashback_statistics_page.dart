import 'package:intl/intl.dart';

import '../../../../commons.dart';
import '../../../components/back_to_button.dart';
import '../viewmodel/cashback_statistic_viewmodel.dart';

// ignore: must_be_immutable
class CashbackStatisticsPage extends ViewModelBuilderWidget<CashbackStatisticViewModel> {
  CashbackStatisticsPage({super.key});

  @override
  void onViewModelReady(CashbackStatisticViewModel viewModel) {
    viewModel.getInit();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, CashbackStatisticViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashback statistics', style: AppTextStyles.body16w5.copyWith(letterSpacing: 0.5)),
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
      body: viewModel.isSuccess(tag: viewModel.tag)
          ? ListView(
              padding: const EdgeInsets.only(top: 10),
              children: [
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: viewModel.cashbackRepository.cashbackStatistics.values.map((e) {
                            double sum = double.parse(e);
                            double h = (sum * 10 / 15);
                            if (h == 0) {
                              h = 10;
                            } else if (h < 20) {
                              h = 20;
                            } else if (h > 150) {
                              h = 150;
                            }
                            return SizedBox(
                              width: 60,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '\$$e',
                                    style: AppTextStyles.body15w6,
                                  ),
                                  Container(
                                    width: 25,
                                    height: h,
                                    color: sum == 0 ? AppColors.textColor.shade3 : AppColors.accentColor,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: AppColors.getPrimaryColor(70),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: viewModel.cashbackRepository.cashbackStatistics.keys
                            .map((e) => Container(
                                  width: 60,
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    e.toString(),
                                    style: AppTextStyles.body15w6,
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
                ...viewModel.cashbackRepository.cashbackStaticList.keys
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: ListTile(
                            tileColor: AppColors.baseLight.shade100,
                            title: Text(
                              DateFormat('dd-MMM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(e)),
                              style: AppTextStyles.body15w6,
                            ),
                            trailing: Text(
                              '+\$${viewModel.cashbackRepository.cashbackStaticList[e]}',
                              style: AppTextStyles.body15w6,
                            ),
                          ),
                        ))
                    .toList()
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  CashbackStatisticViewModel viewModelBuilder(BuildContext context) {
    return CashbackStatisticViewModel(context: context, cashbackRepository: locator.get());
  }
}
