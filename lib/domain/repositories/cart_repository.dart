import '../../data/models/cart_response.dart';

abstract class CartRepository {
  Future<void> clearCart();
  Future<void> addToCart(int id, bool isFav);
  Future<void> setCartFov(String name, {int? favID});
  Future<void> getCartList();
  Future<void> delCartItem(int id);
  Future<void> addTipOrder(String sum, bool isProcent);
  Future<Map<dynamic, dynamic>?> nativePay(String key, double sum);
  Future<String> createOrder(String time, String paymentType, String? cardId);

  CartResponse get cartResponse;
  set cartResponse(CartResponse value);
  List<int> get cartList;
}
