import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:takk/data/models/user_model.dart';

abstract class UserRepository {
  Future<LatLng?> getLocation();

  Future<UserModel> getUserData();

  Future<void> setDeviceInfo();
}
