import '../../data/models/cart_response.dart';

abstract class CartRepository {

  Future<void> clearCart();
  Future<void> addToCart(int id, bool isFav);
  Future<void> setCartFov(String name, {int? favID});
  Future<void> getCartList();

  CartResponse get cartResponse;
  List<int> get cartList ;

}