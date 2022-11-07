import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../commons.dart';
import '../../../widgets/instruction_dialog.dart';
import '../../../widgets/tip_dialog.dart';
import '../viewmodel/ordered_viewmodel.dart';

// ignore: must_be_immutable
class OrderedPage extends ViewModelBuilderWidget<OrderedViewModel> {
  OrderedPage({super.key, required this.curTime, required this.isPickUp, required this.costumTime});

  final int curTime;
  DateTime? costumTime;
  bool isPickUp;

  @override
  Widget builder(BuildContext context, OrderedViewModel viewModel, Widget? child) {
    if (viewModel.cafeModel == null) {
      for (var element in viewModel.cafeRepository.cafeTileList) {
        if (element.id == viewModel.cartRepository.cartResponse.cafe!.id) {
          viewModel.cafeModel = element;
        }
      }
    }

    if (costumTime == null) {
      var st =
          DateTime.parse('${DateFormat('yyyy-MM-dd').format(viewModel.nowDate)} ${viewModel.cafeModel!.openingTime}');
      var en =
          DateTime.parse('${DateFormat('yyyy-MM-dd').format(viewModel.nowDate)} ${viewModel.cafeModel!.closingTime}');
      if (en.hour <= st.hour) {
        en = en.add(const Duration(days: 1));
      }
      if (viewModel.cafeModel!.isOpenNow! && st.isBefore(viewModel.nowDate) && en.isAfter(viewModel.nowDate)) {
        viewModel.nowDate = viewModel.nowDate.add(Duration(minutes: curTime));
      } else {
        viewModel.nowDate = st.add(Duration(days: 1, minutes: curTime));
      }
      viewModel.time =
          '${viewModel.nowDate.day == DateTime.now().day ? 'Today' : 'Tomorrow'} ${DateFormat().add_jm().format(viewModel.nowDate)}';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leadingWidth: 90,
        title: Text(
          'Make payment',
          style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1, letterSpacing: 0.5),
        ),
        leading: TextButton.icon(
            onPressed: () => viewModel.pop(),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text(
              'Back',
              style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
            )),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: AppColors.baseLight.shade100,
            title: Text(
              isPickUp ? 'Pickup time' : 'Estimated time',
              style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
            ),
            subtitle: Text(
              viewModel.time,
              style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
            ),
            trailing: Icon(
              Ionicons.timer_outline,
              size: 25,
              color: AppColors.textColor.shade2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: ListTile(
              onTap: () {
                if (!isPickUp) {
                  viewModel.navigateTo(Routes.addressPage, arg: {
                    'cafeLocation': viewModel.cafeModel!.location,
                    'maxRadius': viewModel.cafeModel!.deliveryMaxDistance!.toDouble(),
                    'inst': viewModel.cartRepository.cartResponse.delivery!.instruction
                  }).then((value) {
                    viewModel.notifyListeners();
                  });
                } else {
                  launchUrl(Uri.parse(
                      'https://www.google.com/maps/dir/?api=1&travelmode=driving&layer=traffic&destination=${viewModel.cafeModel!.location!.coordinates![0]},${viewModel.cafeModel!.location!.coordinates![1]}'));
                }
              },
              tileColor: AppColors.baseLight.shade100,
              title: Text(
                '${isPickUp ? 'Pickup' : 'Delivery'} location',
                style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
              ),
              subtitle: Text(
                isPickUp
                    ? viewModel.cartRepository.cartResponse.cafe!.address ?? ''
                    : viewModel.cartRepository.cartResponse.delivery!.address != null
                        ? viewModel.cartRepository.cartResponse.delivery!.address ?? ''
                        : 'Unknown address',
                style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
              ),
              trailing: Image.asset(
                'assets/icons/ic_loc.png',
                height: 45,
                width: 45,
              ),
            ),
          ),
          if (!isPickUp && viewModel.cartRepository.cartResponse.delivery!.address != null)
            ListTile(
              onTap: () {
                showInstructionDialog(context).then((value) {
                  if (value is String) {
                    viewModel.cartRepository.cartResponse.delivery!.instruction = value;
                    viewModel.notifyListeners();
                  }
                });
              },
              tileColor: AppColors.baseLight.shade100,
              title: Text(
                'Delivery instruction',
                style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
              ),
              subtitle: Text(
                viewModel.cartRepository.cartResponse.delivery!.instruction.isEmpty
                    ? 'No instruction'
                    : viewModel.cartRepository.cartResponse.delivery!.instruction,
                style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
              ),
              trailing: Icon(
                Ionicons.chevron_forward_outline,
                size: 20,
                color: AppColors.textColor.shade2,
              ),
            ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.baseLight.shade100,
                boxShadow: const [BoxShadow(color: Color(0xFFf3f3f4), blurRadius: 10, offset: Offset(0, -2))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a tip (Optional)',
                  style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                ),
                Container(
                  height: 32,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      TextButton(
                        onPressed: () {
                          viewModel.addTipOrderFunc(
                              viewModel.cartRepository.cartResponse.tipPercent == 10 ? '0' : '10', true);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            viewModel.cartRepository.cartResponse.tipPercent == 10
                                ? AppColors.secondaryGreen
                                : AppColors.textColor.shade3,
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          '10%',
                          style: AppTextStyles.body14w5.copyWith(
                            color: viewModel.cartRepository.cartResponse.tipPercent == 10
                                ? AppColors.baseLight.shade100
                                : AppColors.textColor.shade1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                          onPressed: () {
                            viewModel.addTipOrderFunc(
                                viewModel.cartRepository.cartResponse.tipPercent == 15 ? '0' : '15', true);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              viewModel.cartRepository.cartResponse.tipPercent == 15
                                  ? AppColors.secondaryGreen
                                  : AppColors.textColor.shade3,
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black12, width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            '15%',
                            style: AppTextStyles.body15w5.copyWith(
                              color: viewModel.cartRepository.cartResponse.tipPercent == 15
                                  ? AppColors.baseLight.shade100
                                  : AppColors.textColor.shade1,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.addTipOrderFunc(
                            viewModel.cartRepository.cartResponse.tipPercent == 20 ? '0' : '20',
                            true,
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            viewModel.cartRepository.cartResponse.tipPercent == 20
                                ? AppColors.secondaryGreen
                                : AppColors.textColor.shade3,
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black12, width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: Text(
                          '20%',
                          style: AppTextStyles.body14w5.copyWith(
                            color: viewModel.cartRepository.cartResponse.tipPercent == 20
                                ? AppColors.baseLight.shade100
                                : AppColors.textColor.shade1,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextButton(
                          onPressed: () {
                            showTipDialog(context).then((value) {
                              if (value is double) {
                                viewModel.addTipOrderFunc(value.toString(), false);
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              viewModel.cartRepository.cartResponse.tipPercent == 0 &&
                                      viewModel.cartRepository.cartResponse.tip != '0.00'
                                  ? AppColors.secondaryGreen
                                  : AppColors.textColor.shade3,
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black12, width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            double.parse(viewModel.cartRepository.cartResponse.tip) != 0 &&
                                    viewModel.cartRepository.cartResponse.tipPercent == 0
                                ? '\$${viewModel.cartRepository.cartResponse.tip}'
                                : 'Custom Amount',
                            style: AppTextStyles.body14w5.copyWith(
                              color: viewModel.cartRepository.cartResponse.tipPercent == 0 &&
                                      viewModel.cartRepository.cartResponse.tip != '0.00'
                                  ? AppColors.baseLight.shade100
                                  : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    ),
                    Text(
                      '\$${viewModel.numFormat.format(viewModel.cartRepository.cartResponse.subTotalPrice)}',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Divider(
                    height: 1,
                    color: Colors.black12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Free items',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    ),
                    Text(
                      '-\$${viewModel.cartRepository.cartResponse.freeItems}',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Divider(
                    height: 1,
                    color: Colors.black12,
                  ),
                ),
                if (!isPickUp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery fee',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      ),
                      Text(
                        '\$${viewModel.cartRepository.cartResponse.deliveryPrice}',
                        style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                      )
                    ],
                  ),
                if (!isPickUp)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7),
                    child: Divider(
                      height: 1,
                      color: Colors.black12,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax (${viewModel.cartRepository.cartResponse.tax}%)',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    ),
                    Text(
                      '\$${viewModel.cartRepository.cartResponse.taxTotal}',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Divider(
                    height: 1,
                    color: Colors.black12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tip',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    ),
                    Text(
                      '\$${viewModel.cartRepository.cartResponse.tip}',
                      style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Divider(
                    height: 1,
                    color: Colors.black12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.body16w6.copyWith(color: Colors.black87),
                    ),
                    Text(
                      '\$${viewModel.cartRepository.cartResponse.totalPrice}',
                      style: AppTextStyles.body16w6.copyWith(color: Colors.black87),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7),
                  child: Divider(
                    height: 1,
                    color: Colors.black12,
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.navigateTo(Routes.paymentPage, arg: {'isPayment': true}).then((value) {
                    if (value is Map) {
                      viewModel.paymentType = value;
                      viewModel.notifyListeners();
                    }
                  }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          'Pay with',
                          style: AppTextStyles.body15w6.copyWith(color: Colors.black87),
                        ),
                        const Spacer(),
                        Text(
                          viewModel.paymentType == null ? 'Select a card' : viewModel.paymentType!['name'] ?? '',
                          style: AppTextStyles.body14w5,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Ionicons.chevron_forward_outline,
                          size: 20,
                          color: Colors.black87,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(
                    onPressed: () async {
                      viewModel.makePayment(costumTime, curTime);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.secondaryGreen),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      'Make payment',
                      style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  OrderedViewModel viewModelBuilder(BuildContext context) {
    return OrderedViewModel(
      context: context,
      cafeRepository: locator.get(),
      cartRepository: locator.get(),
    );
  }
}
