import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationResult {
  String? address;

  String? placeId;

  LatLng? latLng;

  LocationResult({this.latLng, this.address, this.placeId});

  @override
  String toString() {
    return 'LocationResult{address: $address, latLng: $latLng, placeId: $placeId}';
  }
}
