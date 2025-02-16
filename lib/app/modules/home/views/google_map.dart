import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/app/const/size.dart';
import 'package:maps/app/modules/home/controllers/pip_controller.dart';
import 'package:maps/app/modules/home/controllers/recall_tags.dart';
import 'package:maps/app/modules/home/views/home_drawer.dart';
import '../../../widgets/search_widget.dart';
import '../../../widgets/show_complaint_menu.dart';
import '../../../widgets/tima_distance_widget.dart';
import '../../../widgets/time_distance_pip_widget.dart';
import '../controllers/google_map_controller.dart';

class GoogleMapView extends GetView<MapController> {
  final MapController mapController = Get.find<MapController>();
  final RecallTags recallTags = Get.find<RecallTags>();

  final PipController pipController = Get.find<PipController>();
  final bool language = GetStorage().read('lang') == 'ar';
  
  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenDisabled:  WillPopScope(
        onWillPop: () async {
        pipController.enablePip(context, autoEnable: true); 
        pipController.enablePip(context);
        return false;
      },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: MyDrawer(),
          body: Stack(
            children: [
              Obx(() =>GoogleMap(
                    initialCameraPosition: controller.currentPosition.value,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController mapController) {
                      controller.onMapCreated(mapController);
                      controller.setMapController(mapController);
                      recallTags.fetchAndDisplayHazards(context).then((_) {
                        if (recallTags.markers.isNotEmpty) {
                          print("Markers to display: ${recallTags.markers}");
                        }
                      });
                    },
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: controller.markers.map((marker) {
                      return Marker(
                        markerId: marker.markerId,
                        position: marker.position,
                        infoWindow: InfoWindow(
                          title: marker.infoWindow.title,
                        ),
                        icon: marker.icon,
                        onTap: () {
                          controller.confirmStartTracking("");
                        },
                      );
                    }).toSet(),
                    polylines: {controller.routePolyline.value},
                    onTap: (LatLng position) {
                      controller.selectDestination(position);
                    },
                    onCameraMove: (CameraPosition position) {
                      controller.currentPosition.value = position;
                      controller.onCameraMove(position);
                    },
                  )),
              Positioned(
                top: getHeight(context, 0.04),
                left: language ? getWidth(context, 0.02) : getWidth(context, 0.18),
                right: language ? getWidth(context, 0.18) : getWidth(context, 0.02),
                child: SearchWidget()
              ),
              Positioned(
                top: getHeight(context, 0.79),
                left: getWidth(context, 0.04),
                right: getWidth(context, 0.04),
                child: Obx(() => controller.isPositionedVisible.value
                    ? TimaDistanceWidget()
                    : SizedBox()),
              ),
              Positioned(
                bottom: getHeight(context, 0.35),
                left: language ? getWidth(context, 0.83) : getWidth(context, 0.02),
                right: language ? getWidth(context, 0.02) : getWidth(context, 0.83),
                child: FloatingActionButton(
                  heroTag: "updateCameraButton",
                  onPressed: () async {
                    await controller.updateCameraPosition();
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.my_location,
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
              Positioned(
                bottom: getHeight(context, 0.24),
                left: language ? getWidth(context, 0.83) : getWidth(context, 0.02),
                right: language ? getWidth(context, 0.02) : getWidth(context, 0.83),
                child: FloatingActionButton(
                  heroTag: "addComplaintButton",
                  onPressed: () {
                    showComplaintMenu(controller);
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.report,
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
              Positioned(
                top: getHeight(context, 0.04),
                left: language ? getWidth(context, 0.83) : getWidth(context, 0.02),
                right: language ? getWidth(context, 0.02) : getWidth(context, 0.84),
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    heroTag: "MenuButton",
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.menu,
                        color: Theme.of(context).colorScheme.background),
                  ),
                ),
              ),
              Positioned(
                top: getHeight(context, 0.48),
                left: language ? getWidth(context, 0.83) : getWidth(context, 0.02),
                right: language ? getWidth(context, 0.02) : getWidth(context, 0.84),
                child: Obx(() => FloatingActionButton(
                      heroTag: "sound controller",
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        mapController.isMuted.value
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      onPressed: mapController.toggleMute,
                    )),
              ),
            ],
          ),
        ),
      ),
      childWhenEnabled:  Stack(
        children: [Obx(() => 
GoogleMap(
                    initialCameraPosition: controller.currentPosition.value,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController mapController) {
                      controller.onMapCreated(mapController);
                      controller.setMapController(mapController);
                      recallTags.fetchAndDisplayHazards(context).then((_) {
                        if (recallTags.markers.isNotEmpty) {
                          print("Markers to display: ${recallTags.markers}");
                        }
                      });
                    },
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: controller.markers.map((marker) {
                      return Marker(
                        markerId: marker.markerId,
                        position: marker.position,
                        infoWindow: InfoWindow(
                          title: marker.infoWindow.title,
                        ),
                        icon: marker.icon,
                        onTap: () {
                          controller.confirmStartTracking("");
                        },
                      );
                    }).toSet(),
                    polylines: {controller.routePolyline.value},
                    onTap: (LatLng position) {
                      controller.selectDestination(position);
                    },
                    onCameraMove: (CameraPosition position) {
                      controller.currentPosition.value = position;
                      controller.onCameraMove(position);
                    },
                  ),),
                  Positioned(
                top: getHeight(context, 0.79),
                left: getWidth(context, 0.04),
                right: getWidth(context, 0.04),
                child: Obx(() => controller.isPositionedVisible.value
                    ? TimaDistancePipWidget()
                    : SizedBox()),
              ),]
      ),
                
    );
  }
}