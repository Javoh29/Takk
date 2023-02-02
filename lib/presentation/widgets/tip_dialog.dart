import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/presentation/widgets/text_input_formatter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Future<T?> showTipDialog<T>(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) {
      String sum = '0';
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 200,
          height: 180,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tip',
                style: AppTextStyles.body16w6
                    .copyWith(color: AppColors.textColor.shade1),
              ),
              Text(
                'Enter Custom Amount',
                style: AppTextStyles.body14w5
                    .copyWith(color: AppColors.textColor.shade1),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  style: AppTextStyles.body14w5
                      .copyWith(color: AppColors.textColor.shade1),
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                    prefixText: '\$',
                    prefixStyle: AppTextStyles.body14w5
                        .copyWith(color: AppColors.textColor.shade1),
                    hintText: '\$0.00',
                    hintStyle: AppTextStyles.body14w5
                        .copyWith(color: AppColors.textColor.shade3),
                  ),
                  onChanged: (text) {
                    sum = text;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.body16w6
                          .copyWith(color: AppColors.textColor.shade1),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (sum.isNotEmpty && sum != '0') {
                        try {
                          double d = double.parse(sum);
                          Navigator.pop(context, d);
                        } catch (e) {
                          showTopSnackBar(
                            context,
                            const CustomSnackBar.error(
                              message: 'Enter the amount',
                            ),
                          );
                        }
                      } else {
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.error(
                            message: 'Enter the amount',
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Add',
                      style: AppTextStyles.body16w6
                          .copyWith(color: AppColors.textColor.shade1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
