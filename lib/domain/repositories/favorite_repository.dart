import 'package:takk/data/models/cart_response.dart';

import '../../data/models/product_model.dart';

abstract class FavoriteRepository {
  Future<List<CartResponse>> getFavList(String tag);
  Future<void> clearCart(String tag);
  Future<ProductModel?> getProductInfo(String tag, CartModel cartModel);
  Future<CartResponse> addToCart(String tag, int id, bool isFav);
  Future<void> deleteFavorite(int id);
  Future<void> deleteCartItem(int id);
  Future<void> setCartFov(String name, {int? favID});
  Future<dynamic> getCartList();
}
