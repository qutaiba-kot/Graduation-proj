import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/app/const/size.dart';
import 'package:maps/app/modules/home/views/home_drawer.dart';
import '../../../widgets/show_complaint_menu.dart';
import '../controllers/google_map_controller.dart';
import '../controllers/recall_tags.dart';

class GoogleMapView extends GetView<MapController> {
  final RecallTags recallTags = Get.find<RecallTags>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            // خريطة Google
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
                        // ما يحدث عند النقر على Marker
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
            // مربع البحث عن المواقع
            Positioned(
              top: getHeight(context, 0.04),
              left: getWidth(context, 0.18),
              right: getWidth(context, 0.02),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // لون خلفية TextField
                      borderRadius:
                          BorderRadius.circular(8), // لتطبيق الزوايا المستديرة
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .background, // لون الظل
                          blurRadius: 1, // درجة التمويه
                        ),
                      ],
                    ),
                    child: TextField(
                      cursorColor: Theme.of(context)
                          .colorScheme
                          .background, // لون المؤشر
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .background, // لون النص المكتوب
                      ),
                      decoration: InputDecoration(
                        hintText: "Find a location...".tr,
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .background, // لون النص الإرشادي
                          fontSize: 14, // حجم النص
                        ),
                        filled: true,
                        fillColor: Colors
                            .transparent, // اجعل الخلفية شفافة لأننا نستخدم `Container` للخلفية
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context)
                              .colorScheme
                              .background, // لون الأيقونة
                        ),
                      ),
                      onChanged: (query) {
                        if (query.isNotEmpty) {
                          controller.fetchSearchSuggestions(
                              query); // جلب اقتراحات البحث
                        } else {
                          controller.searchSuggestions
                              .clear(); // مسح الاقتراحات
                        }
                      },
                    ),
                  ),

                  // قائمة الاقتراحات
                  Obx(() => controller.searchSuggestions.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary, // لون خلفية الاقتراحات
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .background, // لون الظل
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background, // لون النص
                                  ), // لون ونمط النص
                                ),
                                onTap: () async {
                                  final placeId = suggestion['place_id'];
                                  final description = suggestion[
                                      'description']; // استخراج الوصف
                                  controller.searchSuggestions
                                      .clear(); // مسح الاقتراحات
                                  await controller.fetchPlaceDetails(
                                      placeId); // جلب تفاصيل المكان
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
            // شريط عرض المسافة والوقت المتبقي
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Distance".tr +
                                  " : " +
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
                              "The time".tr +
                                  " : " +
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

            // زر تحديث الكاميرا لتتبع المستخدم
            Positioned(
              bottom: 285,
              left: 10,
              child: FloatingActionButton(
                heroTag: "updateCameraButton", // تعيين heroTag فريد
                onPressed: () async {
                  await controller
                      .updateCameraPosition(); // تحديث الكاميرا لتتبع موقع المستخدم
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.my_location,
                    color: Theme.of(context).colorScheme.background),
              ),
            ),

            // زر إضافة شكوى
            Positioned(
              bottom: 200,
              left: 10,
              child: FloatingActionButton(
                heroTag: "addComplaintButton", // تعيين heroTag فريد
                onPressed: () {
                  // استدعاء دالة showComplaintMenu
                  showComplaintMenu(controller);
                },

                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.report,
                    color: Theme.of(context).colorScheme.background),
              ),
            ),

            // زر (MenuButton)
            Positioned(
              top: getHeight(context, 0.04),
              right: getWidth(context, 0.84),
              child: Builder(
                builder: (context) => FloatingActionButton(
                  heroTag: "MenuButton", // تعيين heroTag فريد
                  onPressed: () {
                    // فتح الـ Drawer باستخدام Scaffold
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
      ),
    );
  }
}
