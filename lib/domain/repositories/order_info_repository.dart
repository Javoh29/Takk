import 'package:takk/core/domain/entties/order_update_status.dart';
import 'package:takk/data/models/emp_order_model.dart';

abstract class OrderInfoRepository {
  Future<void> getEmpOrder(int id);

  Future<void> setChangeStateEmpOrder(List<int> id, bool isKitchen);

  Future<void> changeStatusOrder(int id, String status);

  EmpOrderModel? get empOrderModel;

  set empOrderModel(EmpOrderModel? value) => empOrderModel = value;
}
