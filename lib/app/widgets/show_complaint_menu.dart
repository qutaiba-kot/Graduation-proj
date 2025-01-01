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
      child: ListView(
        shrinkWrap: true,
        children: HazardTypeService.getHazardTypes()
            .map(
              (hazardType) => ListTile(
                leading: Icon(
                  hazardType.icon,
                  color: Theme.of(Get.context!).colorScheme.primary,
                ),
                title: Text(
                  hazardType.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(Get.context!).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Get.back(); 
                  controller.submitComplaint(hazardType.hazardTypeId);
                },
              ),
            )
            .toList(),
      ),
    ),
    backgroundColor: Colors.transparent,
  );
}
