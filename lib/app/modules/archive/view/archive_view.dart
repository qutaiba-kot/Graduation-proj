import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/widgets/complaints_list_view%20.dart';
import '../controller/archive_controller.dart';

class ArchiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ArchiveController>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'My Reports'.tr,
          style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(
          () {
            if (controller.complaints.isEmpty) {
              return Text('You did not make any reports yet'.tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground));
            }
            return ComplaintsListView( controller: controller);
          },
        ),
      ),
    );
  }
}
