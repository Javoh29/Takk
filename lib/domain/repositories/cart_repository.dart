import '../../data/models/cart_response.dart';

abstract class CartRepository {
  Future<void> getCartList();
  Future<void> delCartItem(int id);
  List<int> get cartList;
  CartResponse get cartResponse;  
}
