import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/home/viewmodel/home_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';
import 'package:takk/presentation/widgets/cafe_item.dart';
import '../../../../core/di/app_locator.dart';
import '../../../widgets/scale_container.dart';
import '../../../widgets/sign_in_dialog.dart';

class HomePage extends ViewModelBuilderWidget<HomeViewModel> {
  HomePage({super.key});

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.initState();
  }

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
              child: locator<LocalViewModel>().bgImage != null
                  ? Image.file(
                      locator<LocalViewModel>().bgImage!,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/img_bg2.jpg',
                      fit: BoxFit.cover,
                    )),
          Positioned.fill(
              child: Container(
            color: const Color(0x20000000),
          )),
          Positioned(
            left: 0,
            top: 70,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 50, 20),
                  decoration: const BoxDecoration(
                    color: Color(0x3500845A),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: Text(
                    'Good ${viewModel.localViewModel.typeDay == 1 ? 'morning' : viewModel.localViewModel.typeDay == 2 ? 'afternoon' : 'evening'}\n${viewModel.localViewModel.isGuest ? 'Guest' : viewModel.localViewModel.userModel!.username}',
                    style: AppTextStyles.body16w6.copyWith(fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleContainer(
                  onTap: () {
                    if (viewModel.localViewModel.isGuest) {
                      showSignInDialog(context);
                    } else {
                      viewModel.navigateTo(Routes.tariffsPage).then(
                        (value) {
                          viewModel.isLoadBudget = true;
                          viewModel.userRepository
                              .getUserData()
                              .then((value) => viewModel.isLoadBudget = false);
                        },
                      );
                    }
                  },
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        height: 40,
                        width: 180,
                        color: const Color(0x3500845A),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Ionicons.wallet_outline,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            if (viewModel.isLoadBudget)
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            else
                              Text(
                                'Budget \$${viewModel.localViewModel.userModel != null ? viewModel.localViewModel.userModel!.balance : '0.00'}',
                                style: AppTextStyles.body16w5,
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 15),
                // ScaleContainer(
                //   onTap: () {
                //     if (isGuest) {
                //       showSignInDialog(context);
                //     } else
                //       Navigator.pushNamed(context, Routes.cashBackPage);
                //   },
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(10),
                //         bottomLeft: Radius.circular(10)),
                //     child: BackdropFilter(
                //       filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                //       child: Container(
                //         height: 40,
                //         width: 180,
                //         color: Color(0x3500845A),
                //         child: Row(
                //           children: [
                //             Padding(
                //               padding:
                //                   const EdgeInsets.symmetric(horizontal: 11),
                //               child: Icon(
                //                 Ionicons.cash_outline,
                //                 size: 20,
                //                 color: Colors.white,
                //               ),
                //             ),
                //             Text(
                //               'CashBack',
                //               style: kTextStyle(fontWeight: FontWeight.w500),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                //   alignment: Alignment.centerRight,
                // ),
                if (!viewModel.localViewModel.isCashier)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ScaleContainer(
                      onTap: () {
                        if (viewModel.localViewModel.isGuest) {
                          showSignInDialog(context);
                        } else {
                          // TODO:
                          viewModel.navigateTo(Routes.latestOrdersPage);
                        }
                      },
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            height: 40,
                            width: 180,
                            color: const Color(0x3500845A),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    Ionicons.list_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Latest orders',
                                  style: AppTextStyles.body16w5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!viewModel.localViewModel.isCashier)
                  ScaleContainer(
                    onTap: () {
                      if (viewModel.localViewModel.isGuest) {
                        showSignInDialog(context);
                      } else {
                        viewModel.navigateTo(Routes.favoritesPage);
                      }
                    },
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          height: 40,
                          width: 180,
                          color: const Color(0x3500845A),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Ionicons.heart_outline,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Favorites',
                                style: AppTextStyles.body16w5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (viewModel.localViewModel.isCashier)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ScaleContainer(
                      onTap: () {
                        if (viewModel.localViewModel.isGuest) {
                          showSignInDialog(context);
                        } else {
                          viewModel.navigateTo(Routes.ordersPage);
                        }
                      },
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            height: 40,
                            width: 180,
                            color: const Color(0x3500845A),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(
                                    Ionicons.list_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text('Orders', style: AppTextStyles.body16w5)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (!viewModel.localViewModel.isCashier)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ScaleContainer(
                      onTap: () {
                        viewModel.navigateTo(Routes.messagesPage);
                      },
                      alignment: Alignment.centerRight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            height: 40,
                            width: 180,
                            color: const Color(0x3500845A),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Image.asset(
                                    'assets/icons/ic_chat.png',
                                    height: 19,
                                    width: 19,
                                  ),
                                ),
                                Text('Messages', style: AppTextStyles.body16w5)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 100),
                  child: ScaleContainer(
                    onTap: () {
                      if (viewModel.localViewModel.isGuest) {
                        showSignInDialog(context);
                      } else {
                        viewModel
                            .navigateTo(Routes.settingsPage)
                            .then((value) => viewModel.notifyListeners());
                      }
                    },
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          height: 40,
                          width: 180,
                          color: const Color(0x3500845A),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Ionicons.settings_outline,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Settings',
                                style: AppTextStyles.body16w5,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SafeArea(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Material(
                  color: const Color(0x3500845A),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 20,
                          right: 0,
                          top: 5,
                          child: Row(
                            children: [
                              Text(
                                'Cafes ${viewModel.localViewModel.isCashier ? '' : 'Location'}',
                                style: AppTextStyles.head16wB
                                    .copyWith(fontSize: 17),
                              ),
                              const Spacer(),
                              if (!viewModel.localViewModel.isCashier)
                                IconButton(
                                  color: Colors.white,
                                  iconSize: 20,
                                  splashRadius: 25,
                                  onPressed: () =>
                                      viewModel.navigateTo(Routes.mapPage),
                                  icon: const Icon(Icons.location_on_rounded),
                                ),
                              IconButton(
                                color: Colors.white,
                                iconSize: 20,
                                splashRadius: 25,
                                onPressed: () {
                                  viewModel.large = !viewModel.large;
                                  viewModel.notifyListeners();
                                },
                                icon: Icon(viewModel.large
                                    ? Ionicons.chevron_up
                                    : Ionicons.chevron_down),
                              )
                            ],
                          ),
                        ),
                        // Consumer<CafeProvider>(
                        //   builder: (context, cafeModel, child) {
                        AnimatedSize(
                          curve: Curves.easeInOutBack,
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            height: viewModel.large ? double.infinity : 175,
                            margin: const EdgeInsets.only(top: 50),
                            child: ListView.builder(
                              scrollDirection: viewModel.large
                                  ? Axis.vertical
                                  : Axis.horizontal,
                              padding: const EdgeInsets.only(left: 15),
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  locator<LocalViewModel>().cafeTileList.length,
                              itemBuilder: (context, index) => CafeItemWidget(
                                  model: locator<LocalViewModel>()
                                      .cafeTileList[index],
                                  padding: const EdgeInsets.only(
                                      right: 15, bottom: 10, top: 5),
                                  tap: () {
                                    viewModel.navigateTo(Routes.cafePage, arg: {
                                      'cafeModel': locator<LocalViewModel>()
                                          .cafeTileList[index],
                                      'isFav': false
                                    });
                                  }),
                            ),
                          ),
                        )
                        //   },
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) {
    return HomeViewModel(
        context: context,
        userRepository: locator.get(),
        localViewModel: locator.get());
  }
}
