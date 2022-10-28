import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/core/services/custom_client.dart';
import 'package:takk/data/models/cafe_model/cafe_model.dart';
import 'package:takk/data/models/user_model.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/di/app_locator.dart';
import '../notif_model.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(this.client);
  final CustomClient client;
  String addressName = '';
  LatLng? currentPosition;
  UserModel? _userModel;

  @override
  Future<LatLng?> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark = newPlace[0];
    addressName = '${placeMark.name}, ${placeMark.administrativeArea}, ${placeMark.country}';
    currentPosition = LatLng(position.latitude, position.longitude);
    return currentPosition;
  }

  @override
  Future<UserModel?> getUserData() async {
    final response = await client.get(Url.getUser);
    if (response.isSuccessful) {
      _userModel = UserModel.fromJson(jsonDecode(response.body));
      return userModel;
    }
    if (response.statusCode == 401) return null;
    throw VMException(response.body.parseError(), response: response, callFuncName: 'getUserData');
  }

  @override
  Future<void> setDeviceInfo() async {
    String? regToken = await FirebaseMessaging.instance.getToken();
    String deviceID = 'Unknown';
    String deviceName = 'Unknown';
    if (Platform.isAndroid) {
      var build = await getAndroidDevInfo();
      deviceID = build.device ?? 'Unknown';
      deviceName = build.model ?? 'Unknown';
    } else if (Platform.isIOS) {
      var build = await getIosDevInfo();
      deviceID = build.identifierForVendor ?? 'Unknown';
      deviceName = build.name ?? 'Unknown';
    }
    final response = await client.post(Url.setDeviceInfo, body: {
      'name': deviceName,
      'registration_id': regToken,
      'device_id': deviceID,
      'active': 'true',
      'type': Platform.isAndroid ? 'android' : 'ios'
    });
    if (!response.isSuccessful) {
      throw VMException(response.body.parseError(), response: response, callFuncName: 'setDeviceInfo');
    }
  }

  @override
  Future<void> setUserData({required String name, required String date, String? imgPath}) async {
    var request = MultipartRequest("PUT", Url.getUser);
    request.fields['username'] = name;
    request.fields['date_of_birthday'] = date;
    request.headers['Authorization'] = 'JWT ${locator<CustomClient>().tokenModel!.access}';
    if (imgPath != null) {
      request.files.add(await MultipartFile.fromPath('avatar', imgPath, contentType: MediaType('image', 'jpeg')));
    }
    var ans = await request.send();
    final response = await Response.fromStream(ans);
    if (response.isSuccessful) {
      _userModel = UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw VMException(response.body.parseError(), callFuncName: 'setUserData', response: response);
    }
  }

  @override
  Future<String?> setFavorite(CafeModel cafeModel) async {
    var response =
        await client.post(Url.changeFavorite(cafeModel.id!), body: {'is_favorite': '${!cafeModel.isFavorite!}'});
    if (response.statusCode == 200) {
      return null;
    } else {
      return "Request Error";
    }
  }

  @override
  UserModel? get userModel => _userModel;

  @override
  set userModel(UserModel? model) => _userModel = model;

  @override
  Future<List<NotifModel>> getUserNotifs(String tag) async {
    var response = await client.get(Url.getUserNotifs);
    if (response.statusCode == 200) {
      List<NotifModel> listNotifs = [
        for (final item in jsonDecode(response.body)['results']) NotifModel.fromJson(item)
      ];
      return listNotifs;
    }
    throw VMException(response.body.parseError(), callFuncName: 'getUserNotifs', response: response);
  }
}
