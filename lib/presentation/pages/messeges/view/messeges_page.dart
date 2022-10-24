import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/comp_model.dart';
import 'package:takk/presentation/pages/messeges/viewmodel/messeges_viewmodel.dart';
import 'package:takk/presentation/widgets/message_widget.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../routes/routes.dart';

class MessegesPage extends ViewModelBuilderWidget<MessegesViewModel> {
  MessegesPage({super.key});

  @override
  Widget builder(BuildContext context, MessegesViewModel viewModel, Widget? child) {
    viewModel.initState();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: AppTextStyles.body16w5.copyWith(color: TextColor().shade1),
        ),
        leading: TextButton.icon(
          onPressed: () => viewModel.pop(),
          icon: Icon(
            Ionicons.chevron_back_outline,
            size: 22,
            color: TextColor().shade1,
          ),
          style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
          label: Text(
            'Back',
            style: AppTextStyles.body16w5.copyWith(color: TextColor().shade1),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.companiesPage).then(
              (value) {
                if (value is CompanyModel) {
                  viewModel.navigateTo(
                    Routes.chatPage,
                    arg: {
                      "chatId": value.id,
                      "name": value.name,
                      "image": value.logoResized ?? "",
                      "isOrder": null,
                    },
                  ).then((value) => viewModel.refNew.currentState!.show());
                }
              },
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.edit,
              size: 20,
              color: TextColor().shade1,
            ),
          ),
        ],
        backgroundColor: AppColors.scaffoldColor,
        leadingWidth: 90,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: viewModel.refNew,
        onRefresh: viewModel.getMessages,
        child: ListView.separated(
          itemBuilder: (context, index) => MessageWidgetPage(
            refNew: viewModel.refNew,
            model: locator<LocalViewModel>().messagesList[index],
          ),
          separatorBuilder: (context, index) => Divider(
            color: TextColor().shade2,
            height: 10,
            indent: 15,
            endIndent: 15,
          ),
          itemCount: locator<LocalViewModel>().messagesList.length,
        ),
      ),
    );
  }

  @override
  MessegesViewModel viewModelBuilder(BuildContext context) {
    return MessegesViewModel(context: context, messageRepository: locator.get());
  }
}
