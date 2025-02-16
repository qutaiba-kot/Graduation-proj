import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/reportation/controllers/reportation_controller.dart';
import '../assets/hazzard types/hazard_types.dart';

class HazardDropdown extends GetView<ReportationController> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => DropdownButton<int>(
            value: controller.selectedProblemId.value == 0
                ? null
                : controller.selectedProblemId.value,
            items: HazardTypeService.getHazardTypes()
                .map(
                  (hazard) => DropdownMenuItem<int>(
                    value: hazard.hazardTypeId,
                    child: Row(
                      children: [
                        Icon(hazard.icon,
                            color: Theme.of(context).colorScheme.onBackground),
                        SizedBox(width: 8),
                        Text(
                          hazard.name,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            hint: Row(
              children: [
                Icon(Icons.warning,
                    color: Theme.of(context).colorScheme.onBackground),
                SizedBox(width: 8),
                Text(
                  'pick the type of the report'.tr,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ],
            ),
            onChanged: (value) {
              controller.selectedProblemId.value = value!;
            },
            dropdownColor: Theme.of(context).colorScheme.primary,
            iconEnabledColor: Theme.of(context).colorScheme.onBackground,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
