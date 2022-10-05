import 'package:project_blueprint/data/models/cafe_model/cafe_model.dart';

abstract class CafeRepository {
  const CafeRepository();
  Future<List<CafeModel>> getCafeList({bool isLoad = false});
}
