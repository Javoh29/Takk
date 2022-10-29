import 'package:jbaza/jbaza.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/order_info_sheet_repository.dart';

class OrderInfoSheetViewModel extends BaseViewModel {
  OrderInfoSheetViewModel({required super.context});

  final String tag = 'OrderInfoSheet';
  CartResponse? model;

  late OrderInfoSheetRepository orderInfoSheetRepository;

  void initState(int id) {
    orderInfoSheetRepository.getOrderInfo(id).then((value) {
      model = value;
      notifyListeners();
    });
  }
}
