import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/emp_order_model.dart';

class OrderInfoWidget extends StatefulWidget {
  OrderInfoWidget({super.key, required this.empOrderModel});

  EmpOrderModel empOrderModel;

  @override
  State<OrderInfoWidget> createState() => _OrderInfoWidgetState();
}

class _OrderInfoWidgetState extends State<OrderInfoWidget> {
  TextStyle widgetStyleText = AppTextStyles.body16w5.copyWith(
    color: AppColors.textColor.shade1,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: widgetStyleText,
              ),
              Text(
                '\$${widget.empOrderModel.subTotalPrice}',
                style: widgetStyleText,
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          thickness: 0.5,
          endIndent: 15,
          indent: 15,
          color: AppColors.textColor.shade1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Free items:',
                style: widgetStyleText,
              ),
              Text(
                '${widget.empOrderModel.freeItems ?? 0}',
                style: widgetStyleText,
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          thickness: 0.5,
          endIndent: 15,
          indent: 15,
          color: AppColors.textColor.shade1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax total:',
                style: widgetStyleText,
              ),
              Text(
                '\$${widget.empOrderModel.taxTotal}',
                style: widgetStyleText,
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          thickness: 0.5,
          endIndent: 15,
          indent: 15,
          color: AppColors.textColor.shade1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tip (${widget.empOrderModel.tipPercent == 0 ? 'Custom' : '${widget.empOrderModel.tipPercent}%'}):',
                  style: widgetStyleText),
              Text(
                '\$${widget.empOrderModel.tip}',
                style: widgetStyleText,
              )
            ],
          ),
        ),
        Divider(
          height: 8,
          thickness: 0.5,
          endIndent: 15,
          indent: 15,
          color: AppColors.textColor.shade1,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 90),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total price:',
                style: AppTextStyles.body16w6.copyWith(
                  color: AppColors.textColor.shade1,
                ),
              ),
              Text(
                '\$${widget.empOrderModel.totalPrice}',
                style: AppTextStyles.body16w6.copyWith(
                  color: AppColors.textColor.shade1,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}