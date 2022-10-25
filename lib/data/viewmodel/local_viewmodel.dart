import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:intl/intl.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/entties/date_time_enum.dart';
import 'package:takk/data/models/tariffs_model.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/data/models/user_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';
import 'package:takk/presentation/widgets/loading_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../models/product_model.dart';
import '../models/user_card_model.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/cafe_model/ctg_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  DateTimeEnum dateTimeEnum = DateTimeEnum.morning;
  File? bgImage;
  UserModel? userModel;
  Future? dialog;

  final MethodChannel _channel =
      const MethodChannel('com.range.takk/callIntent');

  bool isCashier = false;
  bool isGuest = false;
  int typeDay = 1;
  var numFormat = NumberFormat('###,###.00', 'en_US');
  ValueNotifier<bool> notifier = ValueNotifier(false);
  ValueNotifier<List<int>> alarm = ValueNotifier([]);

  List<CafeModel> listCafes = [];
  List<CafeModel> employeesCafeList = [];

  List<CtgModel> headCtgList = [];
  List<int> cartList = [];

  List<CafeModel> get cafeTileList => isCashier ? employeesCafeList : listCafes;
  List<TariffModel> tariffsList = [];
  List<UserCardModel> cardList = [];
  List<CartResponse> ordersList = [];
  CartResponse cartResponse = CartResponse(
      id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  List<CartResponse> favList = [];
  List<dynamic> cafeProducts = [];
  List<ProductModel> listProducts = [];

  // List<CategoryModel> get headCtgList => headCtgList;
  // List<ProductModel> get listProducts => listProducts;
  // List<int> get cartList => _cartList;
  // CartResponse get cartResponse => _cartResponse;

  Future<TokenModel> updateToken() async {
    final tokenModel = await locator<AuthRepository>().updateToken();
    await saveBox<TokenModel>(BoxNames.tokenBox, tokenModel);
    return tokenModel;
  }

  Future<Map<String, dynamic>?> paymentRequestWithCardForm() async {
    final result = await _channel.invokeMethod("stripeAddCard");
    try {
      var m = Map<String, dynamic>();
      m['id'] = result['id'];
      m['last4'] = result['last4'];
      return m;
    } catch (e) {
      print('err: $e');
    }
    return null;
  }

  Future<Map?> confirmSetupIntent(String id, String key, String tag) async {
    safeBlock(() async {
      final result = await _channel.invokeMethod(
          "confirmSetupIntent", {"paymentMethodId": id, "clientSecret": key});
      if (result['success'] != null) {
        await locator<TariffsRepository>().getUserCards();
      }
      return result;
    }, callFuncName: 'confirmSetupIntent', tag: tag);
  }

  @override
  void dispose() async {
    super.dispose();
    await closeBox(BoxNames.tokenBox);
  }

  @override
  callBackError(String text) {
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      dialog = showLoadingDialog(context!);
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
    }
  }
}
