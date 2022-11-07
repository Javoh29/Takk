import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../commons.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/work_graph_dialog.dart';
import '../viewmodel/cafe_info_viewmodel.dart';

// ignore: must_be_immutable
class CafeInfoPage extends ViewModelBuilderWidget<CafeInfoViewModel> {
  CafeInfoPage(this.model, {super.key});

  final CafeModel model;

  @override
  Widget builder(BuildContext context, CafeInfoViewModel viewModel, Widget? child) {
    int weekNum = DateTime.now().weekday - 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leadingWidth: 90,
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Ionicons.chevron_back_outline, size: 22, color: AppColors.textColor.shade1),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text('Back', style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                CacheImage(model.logoSmall ?? '',
                    fit: BoxFit.cover,
                    height: 65,
                    width: 65,
                    borderRadius: 32.5,
                    placeholder: Icon(Ionicons.fast_food_outline, size: 30, color: AppColors.primaryLight)),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name ?? '',
                        style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 30,
                        child: Marquee(
                          text: model.address ?? '',
                          style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade2),
                          velocity: 20,
                          blankSpace: 30,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () => Future.delayed(Duration.zero, () => showWorkGraphDialog(context, model.workingDays ?? [])),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.baseLight.shade100,
                ),
                child: Row(
                  children: [
                    Icon(
                      Ionicons.time_outline,
                      size: 25,
                      color: AppColors.textColor.shade1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '${model.workingDays?[weekNum].openingTime?.substring(0, 5) ?? 'saaaa'} - ${model.workingDays?[weekNum].closingTime?.substring(0, 5) ?? 'saaa'}',
                        style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade54),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                          color: model.isOpenNow ?? false ? AppColors.accentColor : Colors.redAccent,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(model.isOpenNow ?? false ? 'OPEN' : 'CLOSED',
                          style: AppTextStyles.body10w6.copyWith(color: AppColors.baseLight.shade100)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Ionicons.chevron_forward_outline,
                      size: 20,
                      color: AppColors.textColor.shade1,
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(color: AppColors.baseLight.shade100, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                      onTap: () {
                        launchUrl(Uri.parse('tel:${model.callCenter}'));
                      },
                      child: Column(
                        children: [
                          Icon(
                            Ionicons.call_outline,
                            size: 22,
                            color: AppColors.primaryLight,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('Call', style: AppTextStyles.body14w5.copyWith(color: AppColors.primaryLight))
                        ],
                      )),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://www.google.com/maps/dir/?api=1&travelmode=driving&layer=traffic&destination=${model.location!.coordinates![0]},${model.location!.coordinates![1]}'));
                    },
                    child: Column(
                      children: [
                        Icon(
                          Ionicons.map_outline,
                          size: 22,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Location', style: AppTextStyles.body14w5.copyWith(color: AppColors.primaryLight))
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(
                        Ionicons.cafe_outline,
                        size: 22,
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Free Coffee', style: AppTextStyles.body14w5.copyWith(color: AppColors.primaryLight))
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          Ionicons.share_outline,
                          size: 22,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Share', style: AppTextStyles.body14w5.copyWith(color: AppColors.primaryLight))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextButton.icon(
                  onPressed: () => viewModel.navigateTo(Routes.chatPage, arg: {
                        'compId': model.company,
                        'chatId': 0,
                        'name': model.name,
                        'image': model.logoSmall ?? '',
                        'isCreate': true,
                        'isOrder': null
                      }),
                  icon: Icon(
                    Icons.note_alt_outlined,
                    size: 18,
                    color: AppColors.primaryLight,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.baseLight.shade100),
                      shape:
                          MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                  label:
                      Text('Leave a comment', style: AppTextStyles.body15w5.copyWith(color: AppColors.primaryLight))),
            )
          ],
        ),
      ),
    );
  }

  @override
  CafeInfoViewModel viewModelBuilder(BuildContext context) {
    return CafeInfoViewModel(context: context);
  }
}
