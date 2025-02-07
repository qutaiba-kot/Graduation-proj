import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/modules/home/controllers/google_map_controller.dart';

import '../const/size.dart'; 

class TimaDistancePipWidget extends StatefulWidget {
  const TimaDistancePipWidget({super.key});

  @override
  State<TimaDistancePipWidget> createState() => _TimaDistancePipWidgetState();
}

class _TimaDistancePipWidgetState extends State<TimaDistancePipWidget> {
  final MapController controller = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(context, 0.04),
        vertical: getHeight(context, 0.07),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(getWidth(context, 0.06)),
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
          Flexible(
            child: Text(
              controller.remainingDistance.value,
              style: TextStyle(
                fontSize: getWidth(context, 0.085),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.background,
                decoration: TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              controller.remainingDuration.value,
              style: TextStyle(
                fontSize: getWidth(context, 0.085),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.background,
                decoration: TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
