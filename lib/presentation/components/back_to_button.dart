import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_text_styles.dart';

import '../../config/constants/app_colors.dart';

class BackToButton extends StatelessWidget {
  BackToButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.color,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chevron_left,
            color: color ?? Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: AppTextStyles.body16w5
                .copyWith(color: color ?? AppColors.textColor.shade3),
          ),
        ],
      ),
    );
  }
}
