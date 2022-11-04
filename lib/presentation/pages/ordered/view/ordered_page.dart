import 'package:flutter/src/widgets/framework.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/ordered/viewmodel/ordered_viewmodel.dart';

class OrderedPage extends ViewModelBuilderWidget<OrderedViewModel> {
  OrderedPage({super.key, required this.curTime, required this.isPickUp, required this.costumTime});

  final int curTime;
  DateTime? costumTime;
  bool isPickUp;

  @override
  Widget builder(BuildContext context, OrderedViewModel viewModel, Widget? child) {
        
    // TODO: implement builder
    throw UnimplementedError();
  }

  @override
  OrderedViewModel viewModelBuilder(BuildContext context) {
    return OrderedViewModel(context: context);
  }
}
