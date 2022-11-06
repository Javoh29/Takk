import '../../../../commons.dart';
import '../../../../domain/repositories/cafe_repository.dart';
import '../../../widgets/cafe_item.dart';

class PickCafePage extends StatelessWidget {
  const PickCafePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Cafe', style: AppTextStyles.body16w5.copyWith(letterSpacing: .5)),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Ionicons.chevron_back_outline,
              size: 22,
              color: AppColors.textColor.shade1,
            ),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            label: Text(
              'Back',
              style: AppTextStyles.body16w5,
            )),
        centerTitle: true,
        leadingWidth: 90,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: locator<CafeRepository>()
            .cafeTileList
            .map((e) => CafeItemWidget(
                model: e,
                padding: const EdgeInsets.only(bottom: 10, top: 5, left: 15, right: 15),
                isCashier: false,
                isLoad: false,
                onTapFav: () {},
                tap: () {
                  Navigator.pop(context, e);
                }))
            .toList(),
      ),
    );
  }
}
