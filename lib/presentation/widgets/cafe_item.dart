import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:marquee/marquee.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/presentation/widgets/scale_container.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../core/di/app_locator.dart';
import '../../data/models/cafe_model/cafe_model.dart';
import 'cache_image.dart';

class CafeItemWidget extends StatelessWidget {
  const CafeItemWidget(
      {super.key,
      required this.model,
      required this.padding,
      required this.tap});

  final EdgeInsets padding;
  final CafeModel model;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    var s = DateFormat().add_jm().format(DateFormat('HH:mm:ss').parse(
          locator<LocalViewModel>().isCashier
              ? model.openingTime ?? "00:00:00"
              : model.openingTime ?? "23:59:59",
        ));
    var e = DateFormat().add_jm().format(DateFormat('HH:mm:ss').parse(
          locator<LocalViewModel>().isCashier
              ? model.closingTime ?? "00:00:00"
              : model.closingTime ?? "23:59:59",
        ));
    return ScaleContainer(
      onTap: () => tap(),
      child: Container(
        height: 160,
        width: 290,
        margin: padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)]),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: CacheImage(
                model.logoMedium ?? '',
                fit: BoxFit.cover,
                placeholder: Icon(
                  Ionicons.cafe_outline,
                  size: 50,
                  color: AppColors.primaryLight.shade100,
                ),
                borderRadius: 12,
              ),
            ),
            Container(
              height: 85,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                  color: Color(0x70000000),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      model.name ?? '',
                      style: AppTextStyles.head16wB,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Marquee(
                      text: model.address!.isNotEmpty
                          ? model.address!
                          : 'No Address',
                      style: AppTextStyles.body12w5,
                      velocity: 20,
                      blankSpace: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$s - $e',
                        style: AppTextStyles.body12w5,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                            color: model.isOpenNow ?? false
                                ? AppColors.accentColor
                                : Colors.redAccent,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                            model.isOpenNow ?? false ? 'OPEN' : 'CLOSED',
                            style: AppTextStyles.body10w6),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          locator<CafeRepository>()
                              .changeFavorite(model)
                              .then((value) {
                            if (value != null) {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: value,
                                ),
                              );
                            }
                          });
                        },
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: Icon(
                            model.isFavorite ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: model.isFavorite ?? false
                                ? Colors.redAccent
                                : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
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
