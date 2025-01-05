import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/app/const/size.dart';
import 'package:maps/app/modules/home/views/home_drawer.dart';
import '../../../widgets/show_complaint_menu.dart';
import '../controllers/google_map_controller.dart';
import '../controllers/recall_tags.dart';

class GoogleMapView extends GetView<MapController> {
  
  final RecallTags recallTags = Get.find<RecallTags>();
  final bool language = GetStorage().read('lang') == 'ar';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Obx(() => GoogleMap(
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
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.background,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller
                        .textEditingController, // استخدام TextEditingController
                    cursorColor: Theme.of(context).colorScheme.background,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    decoration: InputDecoration(
                      hintText: "Find a location...".tr,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        onPressed: () {
                          controller.textEditingController.clear();
                          controller.searchSuggestions.clear();
                        },
                      ),
                    ),
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        controller.fetchSearchSuggestions(query);
                      } else {
                        controller.searchSuggestions.clear();
                      }
                    },
                  ),
                ),
                Obx(() => controller.searchSuggestions.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.background,
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.searchSuggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion =
                                controller.searchSuggestions[index];
                            return ListTile(
                              title: Text(
                                suggestion['description'],
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                              onTap: () async {
                                controller.textEditingController.clear();
                                final placeId = suggestion['place_id'];
                                final description = suggestion['description'];
                                controller.searchSuggestions.clear();
                                await controller.fetchPlaceDetails(placeId);
                                controller.confirmStartTracking(description);
                              },
                            );
                          },
                        ),
                      )
                    : SizedBox()),
              ],
            ),
          ),
          Positioned(
            top: getHeight(context, 0.79),
            left: getWidth(context, 0.04),
            right: getWidth(context, 0.04),
            child: Obx(() => controller.isPositionedVisible.value
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context, 0.04),
                      vertical: getHeight(context, 0.01),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius:
                          BorderRadius.circular(getWidth(context, 0.02)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.2),
                          blurRadius: getWidth(context, 0.02),
                          offset: Offset(0, getHeight(context, 0.002)),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: Text(
                            controller.remainingDistance.value,
                            style: TextStyle(
                              fontSize: getWidth(context, 0.035),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.stopNavigation();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: getWidth(context, 0.04),
                              vertical: getHeight(context, 0.015),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  getWidth(context, 0.03)),
                            ),
                          ),
                          child: Text(
                            "Stop".tr,
                            style: TextStyle(
                              fontSize: getWidth(context, 0.035),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            controller.remainingDuration.value,
                            style: TextStyle(
                              fontSize: getWidth(context, 0.035),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox()),
          ),
          Positioned(
            bottom: 285,
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
            bottom: 200,
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
        ],
      ),
    );
  }
}
