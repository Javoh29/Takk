import '../../../../commons.dart';
import '../../../../config/constants/assets.dart';
import '../../../components/loading.dart';
import '../viewmodel/splash_viewmodel.dart';

// ignore: must_be_immutable
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
