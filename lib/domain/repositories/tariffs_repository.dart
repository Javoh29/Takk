abstract class TariffsRepository {

  Future<void> getTariffs();
  Future<void> getUserCards();
  Future<String?> getClientSecretKey(String name);
  Future<String?> setBalancePayment(String tag, int tId, int type, int cId);

}