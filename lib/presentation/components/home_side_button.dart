import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/constants/app_text_styles.dart';
import '../widgets/scale_container.dart';

class HomeSideButton extends StatelessWidget {
  const HomeSideButton(
      {Key? key,
      this.padding,
      required this.onTap,
      this.icon,
      required this.label, this.imgAssets})
      : super(key: key);

  final EdgeInsets? padding;
  final Function() onTap;
  final IconData? icon;
  final String label;
  final String? imgAssets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ScaleContainer(
        onTap: onTap,
        alignment: Alignment.centerRight,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              height: 40,
              width: 180,
              color: const Color(0x3500845A),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: icon != null ? Icon(
                      icon,
                      size: 20,
                      color: Colors.white,
                    ) : Image.asset(
                      imgAssets!,
                      height: 19,
                      width: 19,
                    ),
                  ),
                  Text(
                    label,
                    style: AppTextStyles.body16w5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
