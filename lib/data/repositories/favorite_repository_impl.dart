import 'dart:convert';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/models/product_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cart_repository.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import '../../config/constants/urls.dart';
import '../../core/services/custom_client.dart';
import 'package:takk/core/domain/http_is_success.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  FavoriteRepositoryImpl(this.client);

  final CustomClient client;

  List<CartResponse> _favList = [];

  @override
  Future<void> getFavList(String tag) async {
    var response = await client.get(Url.getFavList);
    if (response.isSuccessful) {
      var favList = [for (final item in jsonDecode(response.body)['results']) CartResponse.fromJson(item, isFav: true)];
      _favList = favList;
    } else {
      throw VMException(response.body, response: response, callFuncName: 'getFavList');
    }
  }

  @override
  Future<void> clearCart(String tag) async {
    var response = await client.get(Url.clearCart);
    if (response.isSuccessful) {
      locator<CartRepository>().cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      locator<CartRepository>().cartList.clear();
      await getFavList('FavoritesPage');
    } else {
      throw VMException(response.body, response: response, callFuncName: 'clearCart');
    }
  }

  @override
  Future<CartResponse> addToCart(String tag, int id, bool isFav) async {
    var response = await client.get(isFav ? Url.addFavToCart(id) : Url.addOrderToCart(id));
    if (response.isSuccessful) {
      return CartResponse.fromJson(jsonDecode(response.body));
    }
    throw VMException(response.body, response: response, callFuncName: 'addToCart');
  }

  @override
  Future<ProductModel?> getProductInfo(String tag, CartModel cartModel) async {
    var response = await client.get(Url.getProductInfo(cartModel.product));
    if (response.isSuccessful) {
      return ProductModel.fromJson(response.body);
    }
    throw VMException(response.body, response: response, callFuncName: 'getProductInfo');
  }

  @override
  Future<void> deleteFavorite(int id) async {
    var response = await client.delete(Url.deleteFavorite(id));
    if (!response.isSuccessful) {
      throw VMException(response.body, response: response, callFuncName: 'deleteFavorite');
    }
  }

  @override
  Future<void> deleteCartItem(int id) async {
    var response = await client.delete(Url.deleteCartItem(id));
    if (!response.isSuccessful) {
      throw VMException(response.body, response: response, callFuncName: 'deleteCartItem');
    }
  }

  @override
  Future<void> setCartFov(String name, {int? favID}) async {
    var response = await client.post(Url.setCartFov,
        body: jsonEncode({
          "delivery": {"address": "Unknown", "latitude": 0.0, "longitude": 0.0, "instruction": ""},
          "name": name,
          if (favID != null) "favorite_cart": favID
        }),
        headers: {'Content-Type': 'application/json'});
    if (!response.isSuccessful) {
      throw VMException(response.body, response: response, callFuncName: 'setCartFov');
    }
  }

  @override
  Future<dynamic> getCartList() async {
    var response = await client.get(Url.getCartList);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }

  @override
  List<CartResponse> get favList => _favList;
}
