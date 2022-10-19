import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/entties/date_time_enum.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/data/models/user_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';

import '../models/cafe_model/cafe_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  DateTimeEnum dateTimeEnum = DateTimeEnum.morning;
  File? bgImage;
  UserModel? userModel;

  bool isCashier = false;
  bool isGuest = false;
  int typeDay = 1;
  var numFormat = NumberFormat('###,###.00', 'en_US');
  ValueNotifier<bool> notifier = ValueNotifier(false);
  ValueNotifier<List<int>> alarm = ValueNotifier([]);

  List<CafeModel> listCafes = [];
  List<CafeModel> employeesCafeList = [];
  // CartResponse cartResponse = CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  // List<int> cartList = [];

  List<CafeModel> get cafeTileList => isCashier ? employeesCafeList : listCafes;
  List<MessageModel> messagesList = [];

  // List<CategoryModel> get headCtgList => headCtgList;
  // List<dynamic> get cafeProducts => cafeProducts;
  // List<CartResponse> get favLsit => favList;
  // List<ProductModel> get listProducts => listProducts;
  // List<int> get cartList => _cartList;
  // CartResponse get cartResponse => _cartResponse;

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
