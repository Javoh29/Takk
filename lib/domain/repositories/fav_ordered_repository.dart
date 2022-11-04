import 'dart:ffi';

import 'package:takk/data/models/cart_response.dart';

abstract class FavOrderedRepository {
  Future<void> checkTimestamp(int cafeId, int time);
  Future<void> addToCart(int id, bool isFav);

  CartResponse get cartResponse;
  bool get isAviable;
}
