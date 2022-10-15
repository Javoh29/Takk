import 'dart:convert';

import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import 'package:takk/presentation/pages/favorites/view_model/favorites_viewmodel.dart';
import '../../config/constants/urls.dart';
import '../../core/services/custom_client.dart';
import 'package:takk/core/domain/http_is_success.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  FavoriteRepositoryImpl(this.client);
  final CustomClient client;

  @override
  Future<List<CartResponse>> getFavList(String tag) async {
    var response = await client.get(Url.getFavList);
    if (response.isSuccessful) {
      var favList = [
        for (final item in  jsonDecode(response.body)['results'])
          CartResponse.fromJson(item, isFav: true)
      ];
      locator<LocalViewModel>().favList = favList;
      return favList;
    }
    throw VMException(response.body,
        response: response, callFuncName: 'getFavList');
  }

  @override
  Future<void> clearCart(String tag) async {
    var response = await client.get(Url.clearCart);
    if (response.isSuccessful) {
      locator<LocalViewModel>().cartResponse =
          CartResponse(id: 0, items: [], subTotalPrice: 0.0, cafe: null);
      locator<LocalViewModel>().cartList.clear();
      await getFavList('FavoritesPage');
    }
  }
}
