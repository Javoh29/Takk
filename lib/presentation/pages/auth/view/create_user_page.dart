import 'package:intl/intl.dart';

import '../../../../commons.dart';
import '../../../components/back_to_button.dart';
import '../viewmodel/create_user_viewmodel.dart';

// ignore: must_be_immutable
class CreateUserPage extends ViewModelBuilderWidget<CreateUserViewModel> {
  CreateUserPage({super.key});

  @override
  Widget builder(BuildContext context, CreateUserViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: BackToButton(
          title: 'Back',
          color: TextColor().shade1,
          onPressed: () {
            viewModel.pop();
          },
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: TextButton(
                  onPressed: () {
                    viewModel.setUserDate();
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    'Next',
                    style: AppTextStyles.body16w5,
                  )),
            ),
          )
        ],
        leadingWidth: 85,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introduce yourself',
              style: AppTextStyles.body24wB,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text('Please, provide your name and profile photo',
                  style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade3)),
            ),
            Align(
              alignment: Alignment.center,
              child: viewModel.image == null
                  ? Stack(
                      children: [
                        Container(
                          height: 60,
                          width: 150,
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(color: AppColors.textColor.shade3, borderRadius: BorderRadius.circular(30)),
                          child: TextButton.icon(
                              onPressed: viewModel.getImage,
                              style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                              icon: Icon(
                                Ionicons.camera_outline,
                                size: 24,
                                color: AppColors.textColor.shade1,
                              ),
                              label: Text(
                                'Add Photo',
                                style: AppTextStyles.body16w5,
                              )),
                        ),
                        Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              Ionicons.add_circle,
                              size: 30,
                              color: AppColors.textColor.shade1,
                            ))
                      ],
                    )
                  : GestureDetector(
                      onTap: viewModel.getImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.file(
                          viewModel.image!,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            TextField(
              autofocus: true,
              style: AppTextStyles.body16w5,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: AppTextStyles.body16w4.copyWith(color: Colors.black26),
                prefix: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    'Name',
                    style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 0.8),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 0.8),
                ),
              ),
              onChanged: (text) => viewModel.name = text,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    'Birth date:',
                    style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                Expanded(
                  child: Text(
                    viewModel.selectDate == null ? 'Select' : DateFormat.yMMMd().format(viewModel.selectDate!),
                    style: AppTextStyles.body16w5.copyWith(
                      color: viewModel.selectDate == null ? Colors.black26 : AppColors.textColor.shade1,
                    ),
                  ),
                ),
                IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () => viewModel.showDate(),
                  icon: Icon(
                    Ionicons.chevron_down_outline,
                    color: AppColors.textColor.shade2,
                    size: 20,
                  ),
                )
              ],
            ),
            const Divider(
              height: 1,
              color: Colors.black26,
            )
          ],
        ),
      ),
    );
  }

  @override
  CreateUserViewModel viewModelBuilder(BuildContext context) {
    return CreateUserViewModel(context: context, createUserRepository: locator.get());
  }
}
