import '../../data/models/cart_response.dart';

abstract class LatestOrdersRepository {

  Future<void> getUserOrders();
  Future<void> setOrderLike(int id);
  List<CartResponse> get ordersList;

}
