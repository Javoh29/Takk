import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/hive_box_names.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/entties/date_time_enum.dart';
import 'package:takk/data/models/message_model/last_message.dart';
import 'package:takk/data/models/message_model/message_model.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/models/token_model.dart';
import 'package:takk/domain/repositories/auth_repository.dart';
import 'package:takk/domain/repositories/tariffs_repository.dart';
import 'package:takk/presentation/widgets/loading_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import '../models/companies_model.dart';
import '../models/product_model.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../models/cafe_model/ctg_model.dart';

class LocalViewModel extends BaseViewModel {
  LocalViewModel({required super.context});

  File? bgImage;
  Future? dialog;

  final MethodChannel _channel =
      const MethodChannel('com.range.takk/callIntent');

  bool isCashier = false;
  bool isGuest = false;
  DateTimeEnum typeDay = DateTimeEnum.morning;
  ValueNotifier<bool> notifier = ValueNotifier(false);
  ValueNotifier<List<int>> alarm = ValueNotifier([]);

  List<CtgModel> headCtgList = [];
  List<int> cartList = [];

  List<CartResponse> ordersList = [];
  CartResponse cartResponse = CartResponse(
      id: 0, items: [], subTotalPrice: 0.0, cafe: null, totalPrice: '0.0');
  List<CartResponse> favList = [];
  List<MessageModel> messagesList = [];
  List<LastMessage> lastMessageList = [];
  CartResponse? cartResponseOrder;
  List<CompaniesModel> companiesList = [];

  Future<TokenModel> updateToken() async {
    final tokenModel = await locator<AuthRepository>().updateToken();
    await saveBox<TokenModel>(BoxNames.tokenBox, tokenModel);
    return tokenModel;
  }

  Future<Map<String, dynamic>?> paymentRequestWithCardForm() async {
    final result = await _channel.invokeMethod("stripeAddCard");
    try {
      var m = <String, dynamic>{};
      m['id'] = result['id'];
      m['last4'] = result['last4'];
      return m;
    } catch (e) {
      debugPrint('err: $e');
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
    return null;
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
