import 'package:takk/data/models/cart_response.dart';

abstract class OrderedRepository {
  Future<void> addTipOrder(String sum, bool isProcent);
  Future<Map<dynamic, dynamic>?> nativePay(String key, double sum);
  Future<String> createOrder(String time, String paymentType, String? cardId);

  CartResponse get cartResponse;
}
