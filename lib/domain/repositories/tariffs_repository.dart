import '../../data/models/tariffs_model.dart';
import '../../data/models/user_card_model.dart';

abstract class TariffsRepository {
  Future<void> getTariffs();
  Future<void> getUserCards();
  Future<String?> getClientSecretKey(String name);
  Future<String?> setBalancePayment(String tag, int tId, int type, int cId);
  List<TariffModel> get tariffsList;
  List<UserCardModel> get cardList;
}
