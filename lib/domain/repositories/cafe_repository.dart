import 'package:takk/data/models/cafe_model/cafe_model.dart';

import '../../data/models/cart_response.dart';
import '../../data/models/product_model.dart';

abstract class CafeRepository {
  const CafeRepository();

  Future<List<CafeModel>> getCafeList({String? query, bool isLoad = false});

  Future<void> getEmployeesCafeList({bool isLoad = false});

  Future<void> changeFavorite(CafeModel cafeModel);

  Future<dynamic> getCafeProductList(String tag, int cafeId);

  Future<bool> checkTimestamp(String tag, int cafeId, int time);

  Future<ProductModel?> getProductInfo(String tag, CartModel cartModel);

  List<CafeModel> get listCafes;

  List<CafeModel> get employeesCafeList;

  List<CafeModel> get cafeTileList;

  List<ProductModel> get listProducts;

  set listProducts(List<ProductModel> value);

  Future<void> addItemCart(
      {required String tag,required int cafeId,required ProductModel productModel,required int? cardItem});
}
