import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:takk/data/models/user_model.dart';

import '../../data/models/cafe_model/cafe_model.dart';

abstract class UserRepository {
  Future<LatLng?> getLocation();

  Future<UserModel?> getUserData();

  Future<void> setDeviceInfo();

  Future<String?> setFavorite(CafeModel cafeModel);

  Future<void> setUserData({required String name, required String date, String? imgPath});

  UserModel? get userModel;

  set userModel(UserModel? model);
}
