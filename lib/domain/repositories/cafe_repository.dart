import 'package:takk/data/models/cafe_model/cafe_model.dart';

abstract class CafeRepository {
  const CafeRepository();

  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false});

  Future<List<CafeModel>> getEmployeesCafeList({bool isLoad = false});

  Future<void> changeFavorite(CafeModel cafeModel);

  Future<dynamic> getCafeProductList(String tag, int cafeId);

  List<CafeModel> get listCafes;

  List<CafeModel> get employeesCafeList;

  List<CafeModel> get cafeTileList;
}
