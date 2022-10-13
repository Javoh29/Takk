import 'package:flutter_cache_manager/file.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/entties/date_time_enum.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/data/models/user_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';

import '../models/cafe_model/ctg_model.dart';
import '../models/product_model/product_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  DateTimeEnum dateTimeEnum = DateTimeEnum.morning;
  File? bgImage;
  UserModel? userModel;
  List<CtgModel> headCtgList = [];
  List<CafeModel>  listCafes = [];
  List<dynamic>  cafeProducts = [];
   List<ProductModel> listProducts = [];
   List<int> cartList = [];

  CartResponse cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');


  bool isCashier = false;

  Future<TokenModel> updateToken() async {
    final tokenModel = await locator<AuthRepository>().updateToken();
    await saveBox<TokenModel>(BoxNames.tokenBox, tokenModel);
    return tokenModel;
  }

  @override
  void dispose() async {
    super.dispose();
    await closeBox(BoxNames.tokenBox);
  }

  @override
  callBackError(String text) {}
}
