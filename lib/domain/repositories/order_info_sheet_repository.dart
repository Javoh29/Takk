import 'package:takk/data/models/cart_response.dart';

abstract class OrderInfoSheetRepository {
  Future<CartResponse?> getOrderInfo(int id);
}
