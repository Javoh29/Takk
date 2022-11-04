import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';

class OrderedViewModel extends BaseViewModel {
  OrderedViewModel({required super.context});
  late CafeRepository cafeRepository;
  final String tag = 'OrderedPage';
  Map<dynamic, dynamic>? _paymentType;
  CafeModel? _cafeModel;
  String _clientSecret = '';
  // List<CafeModel> _cafeTileList = [];

  CafeModel? get cafemodel => _cafeModel;
  String get clientSecret => _clientSecret;
  Map<dynamic, dynamic>? get paymentType => _paymentType;
  // List<CafeModel> get cafeTileList => _cafeTileList;
}
