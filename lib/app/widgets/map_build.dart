import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/recall_tags.dart';

import '../modules/home/controllers/google_map_controller.dart';
class MapBuild extends StatelessWidget {
  final MapController controller = Get.find<MapController>();
  final RecallTags recallTags = Get.find<RecallTags>();

  @override
  Widget build(BuildContext context) {
    return GetX<MapController>( // باستخدام GetX بدلاً من Obx
      builder: (controller) {
        return GoogleMap(
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
        );
      },
    );
  }
}
