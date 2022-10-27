import 'package:takk/data/models/emp_order_model.dart';

abstract class OrderRepository {
  Future<EmpOrderModel?> getOrder(String tag, int id);
}
