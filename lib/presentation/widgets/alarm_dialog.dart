import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';

Future<T?> showAlarmDialog<T>(BuildContext context) {
  final String tag = 'alarm_dialog';
  bool isLoad = false;
  return showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (_, setState) => Dialog(
          backgroundColor: AppColors.primaryLight.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Ionicons.cart,
                size: 50,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 10),
                child: Text(
                  'Reminder.',
                  style: AppTextStyles.body20wB,
                ),
              ),
              Text(
                'You have new order. Please, acknowledge it.',
                style: AppTextStyles.body16w5,
              ),
              Container(
                height: 45,
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: isLoad
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() => isLoad = true);
                          // context
                          //     .read<UserProvider>()
                          //     .setEmpAck(tag, alarm.value.first)
                          //     .then((value) {
                          //   setState(() {
                          //     isLoad = false;
                          //   });
                          //   if (context
                          //       .read<UserProvider>()
                          //       .getState(tag) ==
                          //       'success') {
                          //     Future.delayed(
                          //         Duration(milliseconds: 500), () {
                          //       var l = alarm.value;
                          //       l.remove(0);
                          //       alarm.value = l;
                          //       notifier.value = true;
                          //       Navigator.pop(context);
                          //     });
                          //   }
                          // });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: Text(
                          'OK',
                          style: AppTextStyles.body16w5
                              .copyWith(color: AppColors.primaryLight.shade100),
                        ),
                      ),
              )
            ],
          ),
        ),
      );
    },
  );
}
