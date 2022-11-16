import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jbaza/jbaza.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cafe_model/location.dart';
import 'package:takk/domain/repositories/address_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/address_models/address_model.dart';
import '../../../../data/models/address_models/auto_complete_model.dart';
import '../../../../data/models/address_models/location_result.dart';
import '../../../../data/models/cart_response.dart';
import '../../../widgets/info_dialog.dart';
import '../../../widgets/loading_dialog.dart';

class AddressViewModel extends BaseViewModel {
  AddressViewModel(
      {required super.context,
      required this.addressRepository,
      required this.cafeLocation,
      required this.maxRadius,
      required this.instruction});
  AddressRepository addressRepository;

  Location cafeLocation;
  double maxRadius;
  String instruction;

  Future? dialog;

  List<AutoCompleteModel> completeAddresses = [];

  List<AddressModel> listUserAddresses = [];

  Set<Marker> markers = Set();

  LocationResult? locationResult;

  LatLng? currentPosition;

  bool isMove = false;

  final String addAddressTag = 'addAddressTag';

  Future<LocationResult?> reverseGeocodeLatLng(String tag) async {
    safeBlock(() async {
      LocationResult? result =
          await addressRepository.reverseGeocodeLatLng(tag, currentPosition ?? const LatLng(40.703504, -74.016594));
      setSuccess(tag: tag);
      return result;
    }, callFuncName: 'reverseGeocodeLatLng');
    return null;
  }

  Future addMarker({required String tag, required LocationResult? locationResult}) async {
    Uint8List cafeIcon = await getBytesFromAsset('assets/icons/ic_cafe_location.png', 90);
    markers
        .add(Marker(markerId: MarkerId(tag), icon: BitmapDescriptor.fromBytes(cafeIcon), position: currentPosition!));

    locationResult = locationResult;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void autoCompleteSearch(String tag, String place) async {
    safeBlock(() async {
      completeAddresses = await addressRepository.autoCompleteSearch(tag, place) ?? [];

      setSuccess(tag: tag);
    }, callFuncName: 'autoCompleteSearch');
  }

  void getUserLastAddresses(String tag) async {
    safeBlock(() async {
      List<AddressModel>? list = await addressRepository.getUserLastAddresses(tag);
      if (list != null) listUserAddresses = list;
      notifyListeners();
    });
  }

  void funcCameraIdleMove({required String tag, required Completer<GoogleMapController> mapController}) {
    if (isMove) {
      if (arePointsNear(checkPoint: currentPosition!)) {
        reverseGeocodeLatLng(tag).then((value) {
          locationResult = value;
          notifyListeners();
        });
      } else {
        showInfoDialog(context!, 'Out of the delivery range')
            .then((value) => moveToCurrentLocation(mapController: mapController));
      }
      isMove = false;
    }
  }

  Future moveToCurrentLocation({
    LatLng? loc,
    required Completer<GoogleMapController> mapController,
  }) async {
    final controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: loc ?? LatLng(cafeLocation.coordinates![0], cafeLocation.coordinates![1]), zoom: 15),
      ),
    );
  }

  bool arePointsNear({
    required LatLng checkPoint,
  }) {
    var ky = 40000 / 360;
    var kx = cos(pi * cafeLocation.coordinates![0] / 180.0) * ky;
    double dx = (cafeLocation.coordinates![1] - checkPoint.longitude).abs() * kx;
    double dy = (cafeLocation.coordinates![0] - checkPoint.latitude).abs() * ky;
    return sqrt(dx * dx + dy * dy) <= maxRadius / 1000;
  }

  void funcFloatActionButton() async {
    safeBlock(() async {
      if (locationResult != null) {
        showLoadingDialog(context!);
        addressRepository.addAddress(
          addAddressTag,
          DeliveryInfo(
              id: 0,
              address: locationResult!.address,
              latitude: locationResult!.latLng!.latitude.toString(),
              longitude: locationResult!.latLng!.longitude.toString(),
              instruction: instruction),
        );
      }
    }, callFuncName: 'funcFloatActionButton');
  }

  void funcFloatSearchBarButton(Completer<GoogleMapController> controller) {
    safeBlock(() async {
      LatLng? result = await locator<UserRepository>().getLocation();
      if (result != null) {
        if (arePointsNear(checkPoint: result)) {
          currentPosition = result;
          moveToCurrentLocation(loc: currentPosition!, mapController: controller);
        } else {
          showInfoDialog(context!, 'Out of the delivery range').then(
            (value) => moveToCurrentLocation(mapController: controller),
          );
        }
      }
    });
  }

  void funcUserAddressItem1(int index, FloatingSearchBarController floatingSearchBarController,
      Completer<GoogleMapController> mapController) {
    var l = LatLng(
      double.parse(listUserAddresses[index].latitude ?? '0'),
      double.parse(listUserAddresses[index].longitude ?? '0'),
    );
    if (arePointsNear(checkPoint: l)) {
      floatingSearchBarController.close();
      moveToCurrentLocation(loc: l, mapController: mapController);
    } else {
      showInfoDialog(context!, 'Out of the delivery range')
          .then((value) => moveToCurrentLocation(mapController: mapController));
    }
  }

  void funcUserAddressItem2(String tag, int index, Completer<GoogleMapController> mapController,
      FloatingSearchBarController floatingSearchBarController) {
    addressRepository.decodeAndSelectPlace(tag, completeAddresses[index].id).then((value) {
      if (value != null) {
        if (arePointsNear(checkPoint: value)) {
          floatingSearchBarController.close();
          moveToCurrentLocation(loc: value, mapController: mapController);
        } else {
          showInfoDialog(context!, 'Out of the delivery range')
              .then((value) => moveToCurrentLocation(mapController: mapController));
        }
      }
    });
  }

//--------------------------------------------------------------------------------------------
  @override
  callBackBusy(bool value, String? tag) {
    if (dialog == null && isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    Future.delayed(Duration.zero, () {
      if (dialog != null) pop();
    });
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
