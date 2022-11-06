import '../../../../commons.dart';
import '../../../components/back_to_button.dart';
import '../../../widgets/latest_orders_item.dart';
import '../viewmodel/lates_orders_viewmodel.dart';

// ignore: must_be_immutable
class LatestOrdersPage extends ViewModelBuilderWidget<LatestOrdersViewModel> {
  final String tag = 'LatestOrdersPage';
  ScrollController scrollController = ScrollController();

  LatestOrdersPage({super.key});

  @override
  void onViewModelReady(LatestOrdersViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getUserOrder(tag);
  }

  @override
  Widget builder(BuildContext context, LatestOrdersViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Orders', style: AppTextStyles.body16w5.copyWith(letterSpacing: 0.5)),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: BackToButton(
          title: 'Back',
          color: TextColor().shade1,
          onPressed: () {
            viewModel.pop();
          },
        ),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: viewModel.isSuccess(tag: tag)
          ? ListView.separated(
              controller: scrollController,
              itemCount: viewModel.latestOrdersRepository.ordersList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              separatorBuilder: (_, i) => const SizedBox(height: 15),
              itemBuilder: (context, index) =>
                  LatestOrdersItem(modelCart: viewModel.latestOrdersRepository.ordersList[index]),
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  LatestOrdersViewModel viewModelBuilder(BuildContext context) {
    return LatestOrdersViewModel(context: context, latestOrdersRepository: locator.get());
  }

  @override
  void onDestroy(LatestOrdersViewModel model) {
    scrollController.dispose();
  }
}
