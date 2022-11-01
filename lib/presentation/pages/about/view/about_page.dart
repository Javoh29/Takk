import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';

import '../../../../config/constants/hive_box_names.dart';
import '../../../../data/models/comp_model.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String compName = "Undefined";

  @override
  void initState() {
    super.initState();
    companyName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About us', style: AppTextStyles.body16w5),
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
              style: AppTextStyles.body16w5,
            )),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          compName,
          style: AppTextStyles.body15w5,
        ),
      ),
    );
  }

  Future<void> companyName() async {
    var company = await locator<LocalViewModel>().getBox<CompanyModel>(BoxNames.companyBox);
    compName = company?.name ?? "Undefined";
    setState(() {});
  }
}
