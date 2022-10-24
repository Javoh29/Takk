import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takk/presentation/pages/home/viewmodel/home_viewmodel.dart';

import '../../../../config/constants/app_text_styles.dart';
import '../../../../core/di/app_locator.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../routes/routes.dart';
import '../../../widgets/cafe_item.dart';

class CafesLocation extends StatelessWidget {
  const CafesLocation({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          tap: () => locator<HomeViewModel>()
                              .navigateTo(Routes.cafePage, arg: {
                            'cafeModel': locator<LocalViewModel>()
                                .cafeTileList[index],
                            'isFav': false
                          }).then(
                                (value) {
                              viewModel.isLoadBudget = true;
                              viewModel.notifyListeners();
                              viewModel.userRepository.getUserData().then(
                                      (value) =>
                                  viewModel.isLoadBudget = false);
                            },
                          ),
                        ),
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
    );
  }
}
