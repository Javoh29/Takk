import 'dart:ui';

import '../../../../commons.dart';
import '../../../../core/domain/entties/date_time_enum.dart';
import '../../../components/home_side_button.dart';
import '../../../widgets/scale_container.dart';
import '../../../widgets/sign_in_dialog.dart';
import '../viewmodel/home_viewmodel.dart';
import 'cafes_location.dart';

// ignore: must_be_immutable
class HomePage extends ViewModelBuilderWidget<HomeViewModel> {
  HomePage({super.key});

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
                    color: AppColors.customGreen,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                  ),
                  child: Text(
                    'Good ${viewModel.localViewModel.typeDay == DateTimeEnum.morning ? 'morning' : viewModel.localViewModel.typeDay == DateTimeEnum.afternoon ? 'afternoon' : 'evening'}\n${viewModel.localViewModel.isGuest ? 'Guest' : viewModel.userRepository.userModel?.username}',
                    style: AppTextStyles.body16w6.copyWith(fontSize: 17, color: AppColors.textColor.shade3),
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
                          viewModel.loadUserData();
                        },
                      );
                    }
                  },
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        height: 40,
                        width: 180,
                        color: AppColors.customGreen,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Ionicons.wallet_outline,
                                size: 20,
                                color: AppColors.baseLight.shade100,
                              ),
                            ),
                            if (viewModel.isBusy(tag: viewModel.tagUserData))
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.baseLight.shade100),
                                ),
                              )
                            else
                              Text(
                                'Budget \$${viewModel.userRepository.userModel != null ? viewModel.userRepository.userModel!.balance : '0.00'}',
                                style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade3),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!viewModel.localViewModel.isCashier)
                  HomeSideButton(
                    onTap: () {
                      if (viewModel.localViewModel.isGuest) {
                        showSignInDialog(context);
                      } else {
                        viewModel.navigateTo(Routes.latestOrdersPage);
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    icon: Ionicons.list_outline,
                    label: 'Latest orders',
                  ),
                if (!viewModel.localViewModel.isCashier)
                  HomeSideButton(
                    onTap: () {
                      if (viewModel.localViewModel.isGuest) {
                        showSignInDialog(context);
                      } else {
                        viewModel.navigateTo(Routes.favoritesPage);
                      }
                    },
                    icon: Ionicons.heart_outline,
                    label: 'Favorites',
                  ),
                if (viewModel.localViewModel.isCashier)
                  HomeSideButton(
                    onTap: () {
                      if (viewModel.localViewModel.isGuest) {
                        showSignInDialog(context);
                      } else {
                        viewModel.navigateTo(Routes.ordersPage);
                      }
                    },
                    padding: const EdgeInsets.only(top: 15),
                    icon: Ionicons.list_outline,
                    label: 'Orders',
                  ),
                if (!viewModel.localViewModel.isCashier)
                  HomeSideButton(
                    onTap: () {
                      viewModel.navigateTo(Routes.messagesPage);
                    },
                    imgAssets: "assets/icons/ic_chat.png",
                    label: 'Messages',
                    padding: const EdgeInsets.only(top: 15),
                  ),
                HomeSideButton(
                  onTap: () {
                    if (viewModel.localViewModel.isGuest) {
                      showSignInDialog(context);
                    } else {
                      viewModel.navigateTo(Routes.settingsPage).then((value) => viewModel.notifyListeners());
                    }
                  },
                  padding: const EdgeInsets.only(top: 15),
                  icon: Ionicons.settings_outline,
                  label: 'Settings',
                ),
              ],
            ),
          ),
          const CafesLocation(),
        ],
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) {
    return HomeViewModel(context: context, userRepository: locator.get(), localViewModel: locator.get());
  }
}
