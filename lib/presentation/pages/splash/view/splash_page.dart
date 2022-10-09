import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/assets.dart';
import 'package:takk/presentation/components/loading.dart';
import 'package:takk/presentation/pages/splash/viewmodel/splash_viewmodel.dart';

class SplashPage extends ViewModelBuilderWidget<SplashViewModel> {
  SplashPage({super.key});

  @override
  void onViewModelReady(SplashViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadData();
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
