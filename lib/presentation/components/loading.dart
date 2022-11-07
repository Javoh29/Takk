import 'package:flutter/material.dart';

import '../../config/constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.width, this.color, super.key});
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: width ?? 1.5,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.baseLight.shade100),
      ),
    );
  }
}
