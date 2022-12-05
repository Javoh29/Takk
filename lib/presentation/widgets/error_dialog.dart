import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:takk/config/constants/app_text_styles.dart';

Future<T?> showErrorDialog<T>(
    BuildContext context, String errText, bool isInet) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/ic_${isInet ? 'err_connect' : 'error'}.svg',
                    height: 80,
                    width: 80,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    errText,
                    style: AppTextStyles.body12w5
                        .copyWith(color: const Color(0xff4D4D4D)),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Center(
                  child: TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xffE8E8E8)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 20)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
                      child: Text(
                        'Reload',
                        style: AppTextStyles.body14w4
                            .copyWith(color: const Color(0xff4D4D4D)),
                      )),
                )
              ],
            ),
          ),
        );
      });
}
