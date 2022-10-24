import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/product_model/product_model.dart';

abstract class CafeRepository {
  const CafeRepository();
  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false});

  Future<List<CafeModel>> getEmployeesCafeList({bool isLoad = false});

  Future<void> getCartList();

  Future<String?> changeFavorite(CafeModel cafeModel);
}
