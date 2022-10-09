import 'package:takk/data/models/cafe_model/cafe_model.dart';

abstract class CafeRepository {
  const CafeRepository();
  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false});

  Future<List<CafeModel>> getEmployessCafeList({bool isLoad = false});
}
