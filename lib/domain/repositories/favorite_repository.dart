import 'package:takk/data/models/cart_response.dart';

abstract class FavoriteRepository {
  
  Future<void> getFavList(String tag);
  List<CartResponse> get favList ;


}
