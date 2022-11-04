import 'dart:convert';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/fav_ordered_repository.dart';

class FavOrderedRepositoryImpl extends FavOrderedRepository {
  FavOrderedRepositoryImpl(this.client);

  CartResponse _cartResponse = CartResponse(
      id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
      
  late bool _isAviable;
  final CustomClient client;
  @override
  Future<void> addToCart(int id, bool isFav) async {
    var response = await client.get(
      isFav ? Url.addFavToCart(id) : Url.addOrderToCart(id),
    );
    if (response.isSuccessful) {
      _cartResponse = CartResponse.fromJson(jsonDecode(response.body));
    } else {
      throw VMException(response.body.parseError(),
          response: response, callFuncName: 'getMessage');
    }
  }

  @override
  Future<void> checkTimestamp(int cafeId, int time) async {
    var response = await client.get(Url.checkTimestamp(cafeId, time));
    if (response.isSuccessful) {
      _isAviable = jsonDecode(response.body)['available'];
    } else {
      throw VMException(response.body.parseError());
    }
  }

  @override
  CartResponse get cartResponse => _cartResponse;

  @override
  bool get isAviable => _isAviable;
}
