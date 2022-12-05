import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'package:jbaza/jbaza.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/pages/qrcode/viewmodel/qr_code_viewmodel.dart';

class QrcodeViewerPage extends ViewModelBuilderWidget<QrcodeViewModel> {
  QrcodeViewerPage({super.key});

  @override
  Widget builder(
      BuildContext context, QrcodeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qrcode Scaner',
          style: AppTextStyles.body16w5.copyWith(
            color: AppColors.textColor.shade1,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => viewModel.pop(),
          icon: Icon(
            Ionicons.chevron_back_outline,
            size: 22,
            color: AppColors.textColor.shade1,
          ),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          label: Text(
            'Back',
            style: AppTextStyles.body16w5.copyWith(
              color: AppColors.textColor.shade1,
            ),
          ),
        ),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: QRView(
        key: viewModel.qrKey,
        onQRViewCreated: viewModel.onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 200),
        onPermissionSet: (ctrl, p) => viewModel.onPermissionSet(ctrl, p),
      ),
    );
  }

  @override
  QrcodeViewModel viewModelBuilder(BuildContext context) {
    return QrcodeViewModel(context: context);
  }
}
