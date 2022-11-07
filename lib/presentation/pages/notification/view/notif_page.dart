import '../../../../commons.dart';
import '../../../components/back_to_button.dart';
import '../viewmodel/notif_viewmodel.dart';

// ignore: must_be_immutable
class NotifPage extends ViewModelBuilderWidget<NotifViewModel> {
  final String tag = 'NotifPage';

  NotifPage({super.key});
  @override
  void onViewModelReady(NotifViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getNotifs(tag);
  }

  @override
  Widget builder(Object context, NotifViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.body16w5),
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
      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
                tileColor: AppColors.baseLight.shade100,
                title: Text(
                  viewModel.listNotifs[index].title ?? '',
                  style: AppTextStyles.body15w5,
                ),
                subtitle: Text(viewModel.listNotifs[index].body ?? '',
                    style: AppTextStyles.body14w4.copyWith(color: AppColors.textColor.shade2)),
              ),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: viewModel.listNotifs.length),
    );
  }

  @override
  NotifViewModel viewModelBuilder(BuildContext context) {
    return NotifViewModel(context: context, userRepository: locator.get());
  }
}
