import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/assets.dart';
import 'package:project_blueprint/presentation/components/loading.dart';
import 'package:project_blueprint/presentation/pages/splash/viewmodel/splash_viewmodel.dart';

class SplashPage extends ViewModelBuilderWidget<SplashViewModel> {
  SplashPage({super.key});

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.openAuthPage();
  }

  @override
  void onDestroy(SplashViewModel model) {
    super.onDestroy(model);
  }

  @override
  Widget builder(BuildContext context, SplashViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.images.defoultSplash,
              fit: BoxFit.cover,
            ),
          ),
          const LoadingWidget(),
        ],
      ),
    );
  }

  @override
  SplashViewModel viewModelBuilder(BuildContext context) {
    return SplashViewModel(context: context);
  }
}
