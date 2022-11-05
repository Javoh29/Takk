abstract class CashbackRepository {
  Future<void> getCashbackStatistics();

  Future<void> getCashbackList(int period);

  Map<int, String> get cashbackStatistics;

  Map<int, String> get cashbackStaticList;
}
