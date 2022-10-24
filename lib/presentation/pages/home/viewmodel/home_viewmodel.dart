import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/company_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';

import '../../../../core/di/app_locator.dart';
import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../widgets/alarm_dialog.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(
      {required super.context,
      required this.userRepository,
      required this.localViewModel});

  final String tag = 'HomePage';
  late UserRepository userRepository;
  late LocalViewModel localViewModel;
  bool large = false;
  bool isLoadBudget = false;

  initState() {
    locator<LocalViewModel>().alarm.addListener(alarmDialog);
    locator<CafeRepository>().getCartList('cart');
    locator<CompanyRepository>().getCompanyInfo();
    userRepository.getLocation().then((value) => locator<CafeRepository>()
        .getCafeList(isLoad: locator<LocalViewModel>().isCashier));
  }

  alarmDialog() {
    Future.delayed(const Duration(seconds: 5), () {
      if (locator<LocalViewModel>().alarm.value.isNotEmpty) {
        showAlarmDialog(context!);
      }
    });
  }

  Future<String?> changeFavorite(CafeModel cafeModel) async {
    locator<LocalViewModel>()
        .listCafes[locator<LocalViewModel>().listCafes.indexOf(cafeModel)]
        .isFavorite = !cafeModel.isFavorite!;
    notifyListeners();
    safeBlock(() async {
      return await locator<CafeRepository>().changeFavorite(cafeModel);
    }, callFuncName: 'changeFavorite');
    return null;
  }
}
