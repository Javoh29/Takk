import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/presentation/pages/home/viewmodel/home_viewmodel.dart';
import 'package:takk/presentation/routes/routes.dart';

class HomePage extends ViewModelBuilderWidget<HomeViewModel> {
  HomePage({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: const Text('Home Page'),
          onPressed: () {
            viewModel.navigateTo(Routes.createUserPage);
          },
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) {
    return HomeViewModel(context: context);
  }
}
