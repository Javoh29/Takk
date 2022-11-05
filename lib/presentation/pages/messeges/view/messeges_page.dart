import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/company_model.dart';
import 'package:takk/domain/repositories/message_repository.dart';
import 'package:takk/presentation/pages/messeges/viewmodel/messeges_viewmodel.dart';
import 'package:takk/presentation/widgets/message_item.dart';
import '../../../components/back_to_button.dart';
import '../../../routes/routes.dart';

class MessagesPage extends ViewModelBuilderWidget<MessagesViewModel> {
  MessagesPage({super.key});


  @override
  void onViewModelReady(MessagesViewModel viewModel) {
    viewModel.initState();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
      BuildContext context, MessagesViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: AppTextStyles.body16w5.copyWith(color: TextColor().shade1),
        ),
        leading: BackToButton(
          title: 'Back',
          color: TextColor().shade1,
          onPressed: () {
            viewModel.pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () =>
                viewModel.navigateTo(Routes.companiesPage).then((value) {
              if (value is CompanyModel) {
                viewModel.navigateTo(
                  Routes.chatPage,
                  arg: {
                    // chatId = -1 because its chat id is gotten chatPageVIewModel
                    "compId": value.id,
                    "chatId": 0,
                    "name": value.name,
                    "image": value.logoResized ?? "",
                    "isCreate": true,
                    "isOrder": null,
                  },
                ).then(
                  (value) => viewModel.refNew.currentState!.show(),
                );
              }
            }),
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
        onRefresh: () => viewModel
            .getMessagesViewM(viewModel.tag),
        child: ListView.separated(
          itemBuilder: (context, index) => MessageItem(
            model: locator<MessageRepository>().messagesList[index],
            viewModel: viewModel,
          ),
          separatorBuilder: (context, index) => Divider(
            color: TextColor().shade2,
            height: 10,
            indent: 15,
            endIndent: 15,
          ),
          itemCount: locator<MessageRepository>().messagesList.length,
        ),
      ),
    );
  }

  @override
  MessagesViewModel viewModelBuilder(BuildContext context) {
    return MessagesViewModel(
        context: context, messageRepository: locator.get());
  }
}
