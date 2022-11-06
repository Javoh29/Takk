// ignore: must_be_immutable
import '../../../../commons.dart';
import '../viewmodel/pick_cafe_viewmodel.dart';

// ignore: must_be_immutable
class PickCafePage extends ViewModelBuilderWidget<PickCafeViewModel> {
  PickCafePage({super.key});

  @override
  Widget builder(BuildContext context, PickCafeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick Cafe',
          style: AppTextStyles.body16w5.copyWith(
            color: AppColors.textColor.shade1,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Ionicons.chevron_back_outline,
            size: 22,
            color: AppColors.textColor.shade1,
          ),
          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
          label: Text(
            'Back',
            style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1),
          ),
        ),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: viewModel.cafeItemFunc(),
      ),
    );
  }

  @override
  PickCafeViewModel viewModelBuilder(BuildContext context) {
    return PickCafeViewModel(context: context, cafeRepository: locator.get(), localViewModel: locator.get());
  }
}
