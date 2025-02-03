import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assets/hazzard types/hazard_types.dart';
import '../modules/home/controllers/google_map_controller.dart';

void showComplaintMenu(MapController controller) {
  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: GridView.count(
  shrinkWrap: true,
  crossAxisCount: 2, // عدد الأعمدة في الشبكة
  crossAxisSpacing: 10.0, // المسافة بين الأعمدة
  mainAxisSpacing: 10.0, // المسافة بين الصفوف
  childAspectRatio: 2.0,
  children: HazardTypeService.getHazardTypes().map(
    (hazardType) => GestureDetector(
      onTap: () {
        Get.back(); 
        controller.submitComplaint(hazardType.hazardTypeId);
      },
      child: Card(
        color: Theme.of(Get.context!).colorScheme.primary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hazardType.icon,
              color: Theme.of(Get.context!).colorScheme.background,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              hazardType.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(Get.context!).colorScheme.background,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  ).toList(),
)

    ),
    backgroundColor: Colors.transparent,
  );
}
