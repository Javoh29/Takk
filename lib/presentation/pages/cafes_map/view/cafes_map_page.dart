import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jbaza/jbaza.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/presentation/pages/cafes_map/viewmodel/cafes_map_viewmodel.dart';
import 'package:takk/presentation/widgets/cafe_item.dart';

import '../../../../config/constants/app_text_styles.dart';
import '../../../routes/routes.dart';

class CafesMapPage extends ViewModelBuilderWidget<CafesMapViewModel> {
  CafesMapPage({super.key});

  @override
  void onViewModelReady(CafesMapViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initState();
  }

  @override
  Widget builder(
      BuildContext context, CafesMapViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: viewModel.currentPosition != null
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: viewModel.currentPosition!,
                    zoom: 14,
                  ),
                  markers: Set<Marker>.of(viewModel.markers.values),
                  mapToolbarEnabled: true,
                  compassEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    viewModel.setStyle(controller);
                    viewModel.controller.complete(controller);
                    viewModel.moveToCurrentLocation(viewModel.currentPosition!);
                  },
                  onCameraMove: (position) {
                    viewModel.currentPosition = position.target;
                  },
                  onCameraIdle: () => viewModel.onCameraIdle(),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CarouselSlider.builder(
                    itemCount: viewModel.listCafes.length,
                    options: CarouselOptions(
                      viewportFraction: 0.75,
                      initialPage: 1,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        viewModel.moveToCurrentLocation(viewModel
                            .markers[viewModel.listCafes[index].id.toString()]!
                            .position);
                        debugPrint('${viewModel.listCafes[index]}$index');
                      },
                    ),
                    carouselController: viewModel.carouselController,
                    itemBuilder: (context, index, realIdx) {
                      final model = viewModel.listCafes[index];
                      return CafeItemWidget(
                        model: model,
                        padding: const EdgeInsets.all(5),
                        tap: () => viewModel.navigateTo(Routes.cafePage,
                            arg: {'cafe_model': model, 'isFav': false}),
                        isLoad: viewModel.isBusy(tag: model.id.toString()),
                        isCashier: viewModel.localViewModel.isCashier,
                        onTapFav: () => viewModel.changeFavorite(model),
                      );
                    },
                  ),
                ),
                FloatingSearchBar(
                  hint: 'Search...',
                  hintStyle: AppTextStyles.body15w6
                      .copyWith(color: AppColors.textColor.shade2),
                  scrollPadding: const EdgeInsets.only(top: 15, bottom: 56),
                  margins: const EdgeInsets.only(left: 15, right: 15, top: 45),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionCurve: Curves.easeInOut,
                  transition: CircularFloatingSearchBarTransition(),
                  physics: const BouncingScrollPhysics(),
                  openAxisAlignment: 0.0,
                  debounceDelay: const Duration(milliseconds: 300),
                  borderRadius: BorderRadius.circular(12),
                  elevation: 0,
                  height: 45,
                  iconColor: AppColors.textColor.shade1,
                  onQueryChanged: (query) => viewModel.sortCafeList(query),
                  actions: [
                    FloatingSearchBarAction(
                      showIfOpened: false,
                      child: viewModel.isBusy(tag: viewModel.tagSearch)
                          ? Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.textColor.shade1),
                              ),
                            )
                          : CircularButton(
                              icon: Icon(
                                Icons.location_on_rounded,
                                color: AppColors.textColor.shade1,
                                size: 22,
                              ),
                              onPressed: () => viewModel.searchingPress(),
                            ),
                    ),
                  ],
                  builder: (context, transition) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    FloatingSearchBar.of(context)!.close();
                                    viewModel.moveToCurrentLocation(viewModel
                                        .markers[viewModel
                                            .sortedCafeList[index].id
                                            .toString()]!
                                        .position);
                                  },
                                  title: Text(
                                    viewModel.sortedCafeList[index].name ?? '',
                                    style: AppTextStyles.body14w6,
                                  ),
                                  subtitle: Text(
                                    viewModel.sortedCafeList[index].address ??
                                        '',
                                    style: AppTextStyles.body14w5.copyWith(
                                        color: AppColors.textColor.shade2),
                                  ),
                                ),
                            separatorBuilder: (context, index) => Divider(
                                  color: AppColors.textColor.shade2,
                                  height: 1,
                                ),
                            itemCount: viewModel.sortedCafeList.length),
                      ),
                    );
                  },
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }

  @override
  CafesMapViewModel viewModelBuilder(BuildContext context) {
    return CafesMapViewModel(context: context, localViewModel: locator.get());
  }
}
