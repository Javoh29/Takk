import 'package:takk/data/models/emp_order_model.dart';

abstract class OrderInfoRepository {
  Future<EmpOrderModel?> getEmpOrder(int id);
}
