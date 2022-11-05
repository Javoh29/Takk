import 'package:takk/data/models/cafe_model/cafe_model.dart';

import '../../data/models/cart_response.dart';
import '../../data/models/product_model.dart';

abstract class CafeRepository {
  const CafeRepository();

  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false});

  Future<void> getCafeInfo(int id);

  Future<void> getEmployeesCafeList({bool isLoad = false});

  Future<void> changeFavorite(CafeModel cafeModel);

  Future<void> changeStatusProduct(int id, int cafeId, bool isAvailable);

  Future<dynamic> getCafeProductList(int cafeId);

  Future<bool> checkTimestamp(int cafeId, int time);

  Future<ProductModel?> getProductInfo(CartModel cartModel);

  List<CafeModel> get listCafes;

  CafeModel get cafeModel;

  List<CafeModel> get employeesCafeList;

  List<CafeModel> get cafeTileList;

  List<ProductModel> get listProducts;

  set listProducts(List<ProductModel> value);

  Future<void> addItemCart({required int cafeId, required ProductModel productModel, required int? cardItem});
}
