import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/models/emp_order_model.dart';
import 'package:takk/presentation/pages/order_info/viewmodel/order_info_page_viewmodel.dart';

class OrderItemWidget extends StatefulWidget {
  OrderItemWidget(
      {super.key,
      required this.isKitchen,
      required this.item,
      required this.empOrderModel,
      required this.type,
      required this.viewModel});

  Items item;
  bool isKitchen;
  EmpOrderModel empOrderModel;
  int type;
  OrderInfoPageViewModel viewModel;

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.baseLight.shade100,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.item.productName ?? '',
                  style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Checkbox(
                value: widget.item.isReady,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) async {
                  if (!widget.item.isReady! && (widget.type == 1 || widget.type == 2)) {
                    setState(
                      () {
                        if (widget.isKitchen) {
                          widget.empOrderModel.kitchen![widget.empOrderModel.kitchen!.indexOf(widget.item)].isReady =
                              true;
                        } else {
                          widget.empOrderModel.main![widget.empOrderModel.main!.indexOf(widget.item)].isReady = true;
                        }
                      },
                    );
                    await widget.viewModel.setChangeStateEmpOrderFunc([widget.item.id ?? 0], widget.isKitchen);

                    if (widget.isKitchen) {
                      widget.empOrderModel.kitchen![widget.empOrderModel.kitchen!.indexOf(widget.item)].isReady = false;
                    } else {
                      widget.empOrderModel.main![widget.empOrderModel.main!.indexOf(widget.item)].isReady = false;
                    }
                    widget.viewModel.notifyListeners();
                  }
                },
              ),
            ],
          ),
          if (widget.item.productModifiers!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  height: 15,
                  color: Colors.grey[500],
                ),
                Text(
                  'Modifiers:',
                  style: AppTextStyles.body14w5.copyWith(
                    color: AppColors.textColor.shade1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                ...widget.item.productModifiers!.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.name ?? '',
                          style: AppTextStyles.body14w5.copyWith(
                            color: AppColors.getPrimaryColor(99),
                          ),
                        ),
                        Text(
                          '\$${e.price}',
                          style: AppTextStyles.body14w5.copyWith(
                            color: AppColors.getPrimaryColor(99),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          if (widget.item.instruction != null && widget.item.instruction!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  'Instruction:',
                  style: AppTextStyles.body14w5.copyWith(
                    color: AppColors.textColor.shade1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  child: Text(
                    widget.item.instruction ?? '',
                    style: AppTextStyles.body15w5.copyWith(
                      color: AppColors.getPrimaryColor(99),
                    ),
                  ),
                )
              ],
            ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity:',
                style: AppTextStyles.body14w5.copyWith(
                  color: AppColors.textColor.shade1,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '${widget.item.quantity} x',
                style: AppTextStyles.body14w5.copyWith(
                  color: AppColors.textColor.shade1,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          Divider(
            height: 15,
            color: Colors.grey[500],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total price:',
                style: AppTextStyles.body14w6.copyWith(color: AppColors.textColor.shade1),
              ),
              Text(
                '\$${widget.item.subTotalPrice}',
                style: AppTextStyles.body14w6.copyWith(color: AppColors.textColor.shade1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
