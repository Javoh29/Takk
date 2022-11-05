import 'package:takk/data/models/cart_response.dart';

abstract class OrderInfoSheetRepository {
  Future<void> getOrderInfo(int id);

  CartResponse? get cartResponses;
}
