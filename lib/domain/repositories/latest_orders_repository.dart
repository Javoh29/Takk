import '../../data/models/cart_response.dart';

abstract class LatestOrdersRepository {
  Future<void> getUserOrders();
  Future<void> setOrderLike(int id, bool like);
  List<CartResponse> get ordersList;
}
