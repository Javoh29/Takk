import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/presentation/pages/home/viewmodel/home_viewmodel.dart';

class HomePage extends ViewModelBuilderWidget<HomeViewModel> {
  HomePage({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: Center(child: Text('Home Page')),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) {
    return HomeViewModel(context: context);
  }
}
