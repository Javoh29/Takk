import 'package:takk/data/models/emp_order_model.dart';

abstract class OrderInfoRepository {
  Future<EmpOrderModel?> getEmpOrder(int id);

  Future<void> setChangeStateEmpOrder(List<int> id, bool isKitchen);

  EmpOrderModel get empOrderModel;

  set empOrderModel(EmpOrderModel value) => empOrderModel = value;
}
