import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/address_models/address_model.dart';
import '../../data/models/address_models/auto_complete_model.dart';
import '../../data/models/address_models/location_result.dart';
import '../../data/models/cart_response.dart';

abstract class AddressRepository {
  const AddressRepository();
  Future<LocationResult?> reverseGeocodeLatLng(String tag, LatLng latLng);
  Future<List<AutoCompleteModel>?> autoCompleteSearch(String tag, String place);
  Future<List<AddressModel>?> getUserLastAddresses(String tag);
  Future<void> addAddress(String tag, DeliveryInfo model);
  Future<LatLng?> decodeAndSelectPlace(String tag, String? placeId);
}
