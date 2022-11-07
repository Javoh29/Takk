import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../../../commons.dart';
import '../../../../data/models/cafe_model/location.dart';
import '../viewmodel/address_viewmodel.dart';

// ignore: must_be_immutable
class AddressPage extends ViewModelBuilderWidget<AddressViewModel> {
  AddressPage(this.cafeLocation, this.maxRadius, this.instruction, {super.key});

  final Location cafeLocation;
  final double maxRadius;
  final String instruction;

  final String tag = 'AddressPage';
  FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();
  Completer<GoogleMapController> _controller = Completer();
  Set<Circle> _circle = Set();

  @override
  void onViewModelReady(AddressViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.currentPosition = LatLng(viewModel.cafeLocation.coordinates![0], viewModel.cafeLocation.coordinates![1]);
    _circle.add(Circle(
      circleId: CircleId(tag),
      center: viewModel.currentPosition!,
      radius: viewModel.maxRadius,
      fillColor: AppColors.accentColor.withOpacity(0.5),
      strokeColor: AppColors.accentColor,
      strokeWidth: 2,
    ));
    viewModel.reverseGeocodeLatLng(tag).then((value) => viewModel.addMarker(tag: tag, locationResult: value));
    // Future.delayed(Duration.zero, () => showLoadingDialog(context));
    viewModel.getUserLastAddresses(tag);
  }

  @override
  void onDestroy(AddressViewModel model) {
    floatingSearchBarController.dispose();
    super.onDestroy(model);
  }

  Future<void> _setStyle(GoogleMapController controller) async {
    controller.setMapStyle(await rootBundle.loadString('assets/data/map_style.json'));
  }

  // bool calculateRadius(LatLng latLng, AddressViewModel viewModel) {
  //   return pow(viewModel.cafeLocation.coordinates![0] - latLng.latitude, 2) +
  //           pow(viewModel.cafeLocation.coordinates![1] - latLng.longitude, 2) <=
  //       pow(viewModel.maxRadius / 1000 * 0.1988, 2);
  // }

  @override
  Widget builder(BuildContext context, AddressViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: viewModel.currentPosition ?? const LatLng(40.703504, -74.016594),
              zoom: 15,
            ),
            mapToolbarEnabled: true,
            compassEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            circles: _circle,
            markers: viewModel.markers,
            onMapCreated: (GoogleMapController controller) {
              _setStyle(controller);
              _controller.complete(controller);
            },
            onCameraMove: (position) {
              viewModel.currentPosition = position.target;
            },
            onCameraMoveStarted: () {
              viewModel.isMove = true;
            },
            onCameraIdle: () {
              viewModel.funcCameraIdleMove(tag: tag, mapController: _controller);
            },
          ),
          Positioned(
            bottom: 15,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.baseLight.shade100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (viewModel.isSuccess(tag: tag))
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CircularProgressIndicator(),
                    )
                  else
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        child: Text(
                          viewModel.locationResult != null
                              ? viewModel.locationResult!.address ?? 'Unknown address'
                              : 'Unknown address',
                          style: AppTextStyles.body15w6,
                        ),
                      ),
                    ),
                  FloatingActionButton(
                    onPressed: () {
                      viewModel.funcFloatActionButton();
                    },
                    child: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
            ),
          ),
          IgnorePointer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.place, size: 45),
                  Container(
                    decoration: const ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Colors.black38,
                        ),
                      ],
                      shape: CircleBorder(
                        side: BorderSide(
                          width: 4,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
          FloatingSearchBar(
            hint: 'Search...',
            hintStyle: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade2),
            scrollPadding: const EdgeInsets.only(top: 15, bottom: 56),
            margins: const EdgeInsets.only(left: 15, right: 15, top: 45),
            transitionDuration: const Duration(milliseconds: 500),
            transitionCurve: Curves.easeInOut,
            transition: CircularFloatingSearchBarTransition(),
            physics: const BouncingScrollPhysics(),
            openAxisAlignment: 0.0,
            debounceDelay: const Duration(milliseconds: 300),
            borderRadius: BorderRadius.circular(12),
            controller: floatingSearchBarController,
            elevation: 0,
            height: 45,
            iconColor: AppColors.textColor.shade1,
            onQueryChanged: (query) {
              if (query.length > 3) {
                viewModel.autoCompleteSearch(tag, query);
              }
            },
            actions: [
              FloatingSearchBarAction(
                showIfOpened: true,
                child: viewModel.isBusy(tag: tag)
                    ? Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor.shade1),
                        ),
                      )
                    : CircularButton(
                        icon: Icon(
                          Icons.location_on_rounded,
                          color: AppColors.textColor.shade1,
                          size: 22,
                        ),
                        onPressed: () {
                          viewModel.funcFloatSearchBarButton(_controller);
                        }),
              ),
            ],
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: AppColors.baseLight.shade100,
                  elevation: 4.0,
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => floatingSearchBarController.query.isEmpty
                          ? ListTile(
                              contentPadding: const EdgeInsets.only(left: 15),
                              onTap: () {
                                viewModel.funcUserAddressItem1(index, floatingSearchBarController, _controller);
                              },
                              title: Text(
                                viewModel.listUserAddresses[index].address ?? 'Unknown address',
                                style: AppTextStyles.body14w6,
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                  color: AppColors.textColor.shade1,
                                ),
                                iconSize: 20,
                              ),
                            )
                          : ListTile(
                              contentPadding: const EdgeInsets.only(left: 15),
                              onTap: () {
                                viewModel.funcUserAddressItem2(tag, index, _controller, floatingSearchBarController);
                              },
                              title: Text(
                                viewModel.completeAddresses[index].text ?? 'Unknown address',
                                style: AppTextStyles.body14w6,
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.favorite_border,
                                  size: 20,
                                  color: AppColors.textColor.shade1,
                                ),
                                iconSize: 20,
                              ),
                            ),
                      separatorBuilder: (context, index) => Divider(
                            color: AppColors.textColor.shade2,
                            height: 1,
                          ),
                      itemCount: floatingSearchBarController.query.isEmpty
                          ? viewModel.listUserAddresses.length
                          : viewModel.completeAddresses.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  AddressViewModel viewModelBuilder(BuildContext context) {
    return AddressViewModel(
        context: context,
        addressRepository: locator.get(),
        cafeLocation: cafeLocation,
        instruction: instruction,
        maxRadius: maxRadius);
  }
}
