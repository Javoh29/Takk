import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/notif_model.dart';
import '../../../widgets/loading_dialog.dart';

class NotifViewModel extends BaseViewModel {
  NotifViewModel({required super.context, required this.userRepository});
  UserRepository userRepository;
  Future? dialog;
  late List<NotifModel> listNotifs = [];
  getNotifs(String tag) {
    safeBlock(() async {
      listNotifs = await userRepository.getUserNotifs(tag);
      setSuccess();
    }, tag: tag, callFuncName: 'getNotifs');
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    Future.delayed(Duration.zero, () {
      if (dialog != null) pop();
    });
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
