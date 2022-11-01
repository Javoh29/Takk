import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/companies/viewmodel/companies_viewmodel.dart';

import '../../../widgets/cache_image.dart';

class CompaniesPage extends ViewModelBuilderWidget<CompaniesViewModel> {
  CompaniesPage({Key? key}) : super(key: key);

  final String tag = 'CompaniesPage';

  @override
  void onViewModelReady(CompaniesViewModel viewModel) {
    viewModel.getCompList(tag);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
      BuildContext context, CompaniesViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leadingWidth: 90,
        centerTitle: true,
        title: Text(
          'Companies',
          style: AppTextStyles.body16w5,
        ),
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text(
              'Back',
              style: AppTextStyles.body16w5,
            )),
      ),
      body: viewModel.isSuccess(tag: tag)
          ? ListView.separated(
              itemBuilder: (context, index) => ListTile(
                onTap: () => viewModel.pop(
                    result: viewModel.companyRepository.companiesList[index]),
                tileColor: Colors.white,
                title: Text(
                  viewModel.companyRepository.companiesList[index].name ?? '',
                  style: AppTextStyles.body16w6,
                ),
                subtitle: SelectableText(
                  'tel: ${viewModel.companyRepository.companiesList[index].phone}',
                  style: AppTextStyles.body14w5
                      .copyWith(color: AppColors.textColor.shade2),
                ),
                leading: CacheImage(
                  viewModel
                          .companyRepository.companiesList[index].logoResized ??
                      '',
                  fit: BoxFit.cover,
                  placeholder: Icon(
                    Ionicons.cafe_outline,
                    size: 30,
                    color: AppColors.primaryLight.shade100,
                  ),
                  height: 55,
                  width: 55,
                  borderRadius: 30,
                ),
                trailing: Icon(Icons.edit,
                    color: AppColors.textColor.shade1, size: 20),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: viewModel.companyRepository.companiesList.length,
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  CompaniesViewModel viewModelBuilder(BuildContext context) {
    return CompaniesViewModel(
        context: context, companyRepository: locator.get());
  }

}
