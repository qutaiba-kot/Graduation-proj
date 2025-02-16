import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/google_map_controller.dart';

import '../const/size.dart';

class TimaDistanceWidget extends GetView<MapController> {
  const TimaDistanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(context, 0.04),
        vertical: getHeight(context, 0.01),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(getWidth(context, 0.02)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background.withOpacity(0.2),
            blurRadius: getWidth(context, 0.02),
            offset: Offset(0, getHeight(context, 0.002)),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // استخدم Obx لمراقبة المتغيرات
          Flexible(
            child: Obx(
              () => Text(
                controller.remainingDistance.value,
                style: TextStyle(
                  fontSize: getWidth(context, 0.035),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.background,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
              backgroundColor: Theme.of(context).colorScheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(getWidth(context, 0.03)),
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
          // استخدم Obx لمراقبة المتغيرات
          Flexible(
            child: Obx(
              () => Text(
                controller.remainingDuration.value,
                style: TextStyle(
                  fontSize: getWidth(context, 0.035),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.background,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
