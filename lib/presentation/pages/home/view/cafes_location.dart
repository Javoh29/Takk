import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/presentation/pages/home/viewmodel/home_viewmodel.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_styles.dart';
import '../../../routes/routes.dart';
import '../../../widgets/cafe_item.dart';

class CafesLocation extends ViewModelWidget<HomeViewModel> {
  const CafesLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
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
                          style: AppTextStyles.head16wB.copyWith(fontSize: 17, color: AppColors.textColor.shade3),
                        ),
                        const Spacer(),
                        if (!viewModel.localViewModel.isCashier)
                          IconButton(
                            color: Colors.white,
                            iconSize: 20,
                            splashRadius: 25,
                            onPressed: () => viewModel.navigateTo(Routes.mapPage),
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
                          icon: Icon(viewModel.large ? Ionicons.chevron_up : Ionicons.chevron_down),
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
                      child: Builder(builder: (context) {
                        final cafeList = locator<CafeRepository>().cafeTileList;
                        return ListView.builder(
                          scrollDirection: viewModel.large ? Axis.vertical : Axis.horizontal,
                          padding: const EdgeInsets.only(left: 15),
                          physics: const BouncingScrollPhysics(),
                          itemCount: cafeList.length,
                          itemBuilder: (context, index) {
                            final model = cafeList[index];
                            return CafeItemWidget(
                              model: model,
                              padding: const EdgeInsets.only(right: 15, bottom: 10, top: 5),
                              isCashier: viewModel.localViewModel.isCashier,
                              isLoad: viewModel.isBusy(tag: model.id.toString()),
                              onTapFav: () => viewModel.changeFavorite(model),
                              tap: () => viewModel
                                  .navigateTo(Routes.cafePage, arg: {'cafe_model': model, 'isFav': false}).then(
                                (value) {
                                  viewModel.loadUserData();
                                },
                              ),
                            );
                          },
                        );
                      }),
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
