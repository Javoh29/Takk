import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/user_repository.dart';

import '../../../../data/notif_model.dart';

class NotifViewModel extends BaseViewModel {
  NotifViewModel({required super.context, required this.userRepository});
  UserRepository userRepository;
  late List<NotifModel> listNotifs = [];
  getNotifs(String tag) {
    safeBlock(() async {
      listNotifs = await userRepository.getUserNotifs(tag);
      setSuccess();
    });
  }
}
