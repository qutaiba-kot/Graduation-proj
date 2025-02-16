import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps/app/const/size.dart';
import 'package:maps/app/modules/reportation/controllers/reportation_controller.dart';
import 'package:maps/app/widgets/attach_photo.dart';
import '../../../global/text_feild.dart';
import '../../../widgets/hazzard_dropdown.dart';

class ReportationView extends GetView<ReportationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(  
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'File a complaint'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(children: [
                    Text("Required : ".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground))
                  ])),
              HazardDropdown(controller: controller),
              SizedBox(height: getHeight(context, 0.01)),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(children: [
                    Text("Required : ".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground))
                  ])),
              Card(
                color: Theme.of(context).colorScheme.primary,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CustomTextField(
                    controller: controller.descriptionController,
                    maxLines: 3,
                    hintText: 'Write a brief description of the problem...'.tr,
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    labelStyle:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    borderRadius: 8.0,
                    borderColor: Theme.of(context).colorScheme.background,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    textColor: Theme.of(context).colorScheme.onBackground,
                    cursorColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 0.01)),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(children: [
                    Text("Required : ".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground))
                  ])),
              AttachPhoto(controller: controller),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(children: [
                    Text("Required : ".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground))
                  ])),
              Card(
                color: Theme.of(context).colorScheme.primary,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await controller.getCurrentLocation();
                        },
                        icon: Icon(Icons.location_on),
                        label: Text('Use of the current location'.tr),
                      ),
                      SizedBox(height: 8),
                      Obx(
                        () => Text(
                          controller.latitude.value != 0.0 &&
                                  controller.longitude.value != 0.0
                              ? '${'current_location'.tr}\n${'latitude'.tr}: ${controller.latitude.value}\n${'longitude'.tr}: ${controller.longitude.value}'
                              : 'Location not yet determined'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitComplaint,
                  child: Text('Submit a complaint'.tr),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}