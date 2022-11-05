import 'dart:convert';
import 'dart:io';

import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/urls.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/core/domain/detail_parse.dart';
import 'package:takk/core/domain/http_is_success.dart';
import 'package:takk/data/models/address_models/address_model.dart';
import 'package:takk/data/models/address_models/location_result.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/domain/repositories/address_repository.dart';

import '../../core/services/custom_client.dart';
import '../../core/utils/location_utils.dart';
import '../models/address_models/auto_complete_model.dart';

class AddressRepositoryImpl extends AddressRepository {
  const AddressRepositoryImpl(this.client);
  final CustomClient client;
  @override
  Future<LocationResult?> reverseGeocodeLatLng(
      String tag, LatLng latLng) async {
    final endpoint =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}"
                "&key=${Platform.isIOS ? 'AIzaSyDi2i0HqPy63HuDJ4ralb4AlSKSWXf-L44' : 'AIzaSyDfIvO5LEEp1TOUmM4VcP2IoFgFtFflbvQ'}" +
            "&language=en";

    final response = await client.get(Uri.parse(endpoint),
        headers: await (LocationUtils.getAppHeaders()));
    if (response.isSuccessful) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);

      String? road;

      String? placeId = responseJson['results'][0]['place_id'];

      if (responseJson['status'] == 'REQUEST_DENIED') {
        road = 'REQUEST DENIED = please see log for more details';
        print(responseJson['error_message']);
      } else {
        road = responseJson['results'][0]['formatted_address'];
      }
      // setState(tag, 'success');
      return LocationResult(address: road, placeId: placeId, latLng: latLng);
    } else {
      throw VMException(response.body.parseError());
    }
  }

  @override
  Future<List<AutoCompleteModel>?> autoCompleteSearch(
      String tag, String place) async {
    List<AutoCompleteModel> completeAddresses = [];
    place = place.replaceAll(" ", "+");
    var endpoint =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=${Platform.isIOS ? 'AIzaSyDi2i0HqPy63HuDJ4ralb4AlSKSWXf-L44' : 'AIzaSyDfIvO5LEEp1TOUmM4VcP2IoFgFtFflbvQ'}&input={$place}&sessiontoken=${locator<CustomClient>().tokenModel!.access}&language=en";

    final headers = await LocationUtils.getAppHeaders();
    final response = await client.get(Uri.parse(endpoint), headers: headers);

    if (response.isSuccessful) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> predictions = data['predictions'];
      completeAddresses.clear();
      for (dynamic t in predictions) {
        AutoCompleteModel aci = AutoCompleteModel();
        aci.id = t['place_id'];
        aci.text = t['description'];
        aci.offset = t['matched_substrings'][0]['offset'];
        aci.length = t['matched_substrings'][0]['length'];

        completeAddresses.add(aci);
      }
      return completeAddresses;
    } else {
      throw VMException(response.body.toString().parseError(),
          callFuncName: 'autoCompleteSearch');
    }
  }

  @override
  Future<List<AddressModel>?> getUserLastAddresses(String tag) async {
    var response = await client.get(Url.getUserLastAddresses);
    if (response.isSuccessful) {
      List<AddressModel> list = [
        for (final item in jsonDecode(response.body))
          AddressModel.fromJson(item)
      ];
      return list;
    }

    {
      throw VMException(response.body.parseError(),
          callFuncName: 'getUserLastAddresses');
    }
  }

  @override
  Future<void> addAddress(String tag, DeliveryInfo model) async {
    var response = await client.post(
      Url.addDeliveryAddress,
    );
    if (response.isSuccessful) {
      // TO DO GET CARTRESPONSE AND SET VALUE
      // _cartResponse = CartResponse.fromJson(jsonDecode(response.body));
    }
  }

  @override
  Future<LatLng?> decodeAndSelectPlace(String tag, String? placeId) async {
    final endpoint =
        "https://maps.googleapis.com/maps/api/place/details/json?key=${Platform.isIOS ? 'AIzaSyDi2i0HqPy63HuDJ4ralb4AlSKSWXf-L44' : 'AIzaSyDfIvO5LEEp1TOUmM4VcP2IoFgFtFflbvQ'}"
                "&placeid=$placeId" +
            '&language=en';

    final headers = await LocationUtils.getAppHeaders();
    final response = await client.get(Uri.parse(endpoint), headers: headers);
    if (response.isSuccessful) {
      Map<String, dynamic> location =
          jsonDecode(response.body)['result']['geometry']['location'];
      LatLng latLng = LatLng(location['lat'], location['lng']);
      return latLng;
    } else {
      throw VMException(response.body.toString().parseError(), callFuncName: 'decodeAndSelectPlace');
    }
  }
}
