import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:takk/presentation/widgets/cache_image.dart';
import 'package:takk/presentation/widgets/ticket_clipper.dart';

import '../../config/constants/app_colors.dart';
import '../../config/constants/app_text_styles.dart';
import '../../data/models/cart_response_model.dart';
import '../pages/latest_order_page/viewmodel/lates_orders_viewmodel.dart';
import '../routes/routes.dart';
import 'line_dash.dart';

class LatestOrdersItem extends StatelessWidget {
  LatestOrdersItem({
    Key? key,
    required this.viewModel,
    required this.modelCart,
  }) : super(key: key);

  CartResponse modelCart;
  LatestOrdersViewModel viewModel;

  final String tagSetOrderLike = 'tagSetOrderLike';
  final String tagSetCartFov = 'tagSetCartFov';
  final String tagAddToCart = 'tagAddToCart';

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  modelCart.cafe!.name ?? '',
                  style: AppTextStyles.body14w6,
                ),
                subtitle: Row(
                  children: [
                    Text(
                      'Status: ',
                      style: AppTextStyles.body14w5
                          .copyWith(color: AppColors.textColor.shade2),
                    ),
                    Text(
                      modelCart.status ?? 'unknown',
                      style: AppTextStyles.body16w6
                          .copyWith(color: AppColors.accentColor),
                    )
                  ],
                ),
                leading: CacheImage(
                  modelCart.cafe!.logoSmall ?? '',
                  fit: BoxFit.cover,
                  height: 40,
                  width: 40,
                  borderRadius: 20,
                  placeholder: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Ionicons.fast_food_outline,
                      size: 30,
                      color: AppColors.primaryLight.shade100,
                    ),
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Text(
                        '${modelCart.delivery!.address != null ? 'Delivery time' : 'Pickup time'}: ${DateFormat('MMM dd, yyyy - (').add_jm().format(DateTime.fromMillisecondsSinceEpoch(modelCart.preOrderTimestamp ?? 0))})',
                        style: AppTextStyles.body14w5,
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.textColor.shade3,
                    endIndent: 15,
                    indent: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Text(
                        'Order ID: #${modelCart.id}',
                        style: AppTextStyles.body14w5,
                      ),
                    ),
                  ),
                  ...modelCart.items
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                Divider(
                                  height: 1,
                                  color: AppColors.textColor.shade3,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.productName,
                                        style: AppTextStyles.body14w5),
                                    Text(
                                      '\$${e.productPrice}',
                                      style: AppTextStyles.body14w5,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  Divider(
                    height: 1,
                    endIndent: 15,
                    indent: 15,
                    color: AppColors.textColor.shade3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tax',
                          style: AppTextStyles.body14w5,
                        ),
                        Text(
                          '\$${modelCart.taxTotal}',
                          style: AppTextStyles.body14w5,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    endIndent: 15,
                    indent: 15,
                    color: AppColors.textColor.shade3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tip',
                          style: AppTextStyles.body14w5,
                        ),
                        Text(
                          '\$${modelCart.tip}',
                          style: AppTextStyles.body14w5,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    endIndent: 15,
                    indent: 15,
                    color: AppColors.textColor.shade3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery fee',
                          style: AppTextStyles.body14w5,
                        ),
                        Text(
                          '\$${modelCart.deliveryPrice}',
                          style: AppTextStyles.body14w5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              indent: 15,
              endIndent: 15,
              color: AppColors.textColor.shade3,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: AppTextStyles.body14w6),
                  Text(
                    '\$${modelCart.totalPrice}',
                    style: AppTextStyles.body14w6,
                  )
                ],
              ),
            ),
            LineDash(
              color: AppColors.textColor.shade2,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 11),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => viewModel.navigateTo(Routes.tariffsPage),
                    child: Row(
                      children: [
                        Text(
                          '+\$${modelCart.cashback} ',
                          style: AppTextStyles.body18w6
                              .copyWith(color: AppColors.accentColor),
                        ),
                        Text(
                          'CashBack',
                          style: AppTextStyles.body12w6,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        viewModel.setFavorite(tagSetOrderLike, modelCart);
                      },
                      icon: Image.asset(
                        'assets/icons/ic_smile_${modelCart.like == null ? 'grey' : modelCart.like! ? 'yellow' : 'red'}.png',
                        height: 22,
                        width: 22,
                      )),
                  IconButton(
                      onPressed: () =>
                          viewModel.navigateTo(Routes.chatPage, arg: {
                            'chatId': modelCart.id,
                            'name': 'Order ID${modelCart.id}',
                            'image': modelCart.cafe?.logoSmall ?? '',
                            'isCreate': true,
                            'isOrder': modelCart.id
                          }),
                      icon: Image.asset(
                        'assets/icons/ic_chat_dark.png',
                        height: 20,
                        width: 20,
                      )),
                  IconButton(
                      onPressed: () => viewModel.showAddFavorite(
                          tagAddToCart, tagSetCartFov, modelCart),
                      icon: Icon(
                        Icons.favorite_border,
                        color: AppColors.textColor.shade1,
                        size: 25,
                      )),
                  IconButton(
                    onPressed: () => viewModel.navigateTo(Routes.favOrderedPage,
                        arg: {'cafeRes': modelCart, 'isFav': false}),
                    icon: Icon(
                      Icons.replay,
                      color: AppColors.textColor.shade1,
                      size: 25,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
