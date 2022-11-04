import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';

class PaymentViewModel extends BaseViewModel {
  PaymentViewModel({required super.context, required this.tariffsRepository, required this.userRepository});
  TariffsRepository tariffsRepository;
  UserRepository userRepository;
  getUserCards(String tag) {
    safeBlock(() async {
      
    });
  }

  getUserData(String tag) {
    safeBlock(() async {

    });
  }
}
