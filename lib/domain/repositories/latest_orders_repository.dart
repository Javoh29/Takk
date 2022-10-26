abstract class LatestOrdersRepository {
  Future<void> getUserOrders();
  Future<void> setOrderLike(int id);
  Future<void> addToCart(int id, bool isFav);
  Future<void> setCartFov(String name, {int? favID});
}
