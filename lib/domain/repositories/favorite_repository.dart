import 'package:takk/data/models/cart_response.dart';

abstract class FavoriteRepository {
  
  Future<List<CartResponse>> getFavList(String tag);
  Future<void> clearCart(String tag);
}
