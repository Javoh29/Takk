import '../../data/models/cashback_model.dart';

abstract class CashbackRepository {
  Future<void> getCashbackStatistics();

  Future<void> getCashbackList(int period);

  Map<int, String> get cashbackStatistics;

  List<CashbackModel> get cashbackStaticList;
}
