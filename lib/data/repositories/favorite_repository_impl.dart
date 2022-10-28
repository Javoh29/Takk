import 'dart:convert';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/favorite_repository.dart';
import '../../config/constants/urls.dart';
import '../../core/services/custom_client.dart';
import 'package:takk/core/domain/http_is_success.dart';

class FavoriteRepositoryImpl extends FavoriteRepository {
  FavoriteRepositoryImpl(this.client);

  final CustomClient client;

  List<CartResponse> _favList = [];

  @override
  Future<void> getFavList(String tag) async {
    var response = await client.get(Url.getFavList);
    if (response.isSuccessful) {
      var favList = [
        for (final item in jsonDecode(response.body)['results'])
          CartResponse.fromJson(item, isFav: true)
      ];
      _favList = favList;
    } else {
      throw VMException(response.body,
        response: response, callFuncName: 'getFavList');
    }
  }

  @override
  List<CartResponse> get favList => _favList;
}
