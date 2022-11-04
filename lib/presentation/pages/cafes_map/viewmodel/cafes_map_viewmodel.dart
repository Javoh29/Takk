import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/domain/repositories/cafe_repository.dart';
import 'package:takk/domain/repositories/user_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../data/models/cafe_model/cafe_model.dart';
import '../../../widgets/loading_dialog.dart';

class CafesMapViewModel extends BaseViewModel {
  CafesMapViewModel({required super.context, required this.localViewModel});

  final String tag = 'MapPage';
  final String tagSearch = 'tagSearch';
  final Completer<GoogleMapController> controller = Completer();
  CarouselController carouselController = CarouselController();
  LocalViewModel localViewModel;
  LatLng? currentPosition;
  Map<String, Marker> markers = <String, Marker>{};
  List<CafeModel> listCafes = [];
  Future? dialog;

  // TODO: Google map ko'rinmayapti

  Future moveToCurrentLocation(LatLng loc) async {
    final control = await controller.future;
    control.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: loc, zoom: 17),
    ));
  }

  void initState() {
    listCafes = locator<CafeRepository>().cafeTileList;
    for (var element in listCafes) {
      addMarker(
          element.id.toString(),
          element.name ?? '',
          element.address ?? '',
          element.location!.coordinates![0],
          element.location!.coordinates![1]);
    }
    Future.delayed(Duration.zero, () => buildInit());
  }

  void buildInit() {
    safeBlock(() async {
      if (currentPosition == null) {
        if (locator<UserRepository>().currentPosition != null) {
          currentPosition = locator<UserRepository>().currentPosition;
        } else {
          await locator<UserRepository>().getLocation();
        }
      }
      setSuccess(tag: tag);
    }, callFuncName: 'buildInit', tag: tag, inProgress: false);
  }

  void addMarker(
      String id, String name, String address, double lat, double lon) {
    final MarkerId markerId = MarkerId(id);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(
          title: name,
          snippet: address,
        ));
    markers[id] = marker;
  }

  Future<void> setStyle(GoogleMapController controller) async {
    controller
        .setMapStyle(await rootBundle.loadString('assets/data/map_style.json'));
  }

  searchingPress() {
    safeBlock(() async {
      var value = await locator<UserRepository>().getLocation();
      currentPosition = value;
      await moveToCurrentLocation(currentPosition!);
      setSuccess(tag: tagSearch);
    }, callFuncName: 'searchingPress', tag: tagSearch);
  }

  changeFavorite(CafeModel cafeModel) {
    safeBlock(() async {
      await locator<CafeRepository>().changeFavorite(cafeModel);
      cafeModel.isFavorite = !cafeModel.isFavorite!;
      setSuccess(tag: cafeModel.id.toString());
    }, callFuncName: 'changeFavorite', tag: cafeModel.id.toString());
  }

  onCameraIdle() {
    currentPosition ??= locator<UserRepository>().currentPosition;
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
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
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }
}
