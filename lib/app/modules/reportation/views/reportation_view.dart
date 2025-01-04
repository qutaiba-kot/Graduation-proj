import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps/app/const/size.dart';
import 'package:maps/app/modules/reportation/controllers/reportation_controller.dart';
import '../../../assets/hazzard types/hazard_types.dart';
import '../../../global/text_feild.dart';

class ReportationView extends GetView<ReportationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'File a complaint'.tr,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
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
              Icon(
                Icons.report,
                size: 110,
                color: Theme.of(context).colorScheme.primary,
              ),
              Card(
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
                                  SizedBox(width: 8),
                                  Text(
                                    hazard.name,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      hint: Row(
                        children: [
                          Icon(Icons.warning,
                              color: Theme.of(context).colorScheme.background),
                          SizedBox(width: 8),
                          Text(
                            'pick the type of the report'.tr,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                        ],
                      ),
                      onChanged: (value) {
                        controller.selectedProblemId.value = value!;
                      },
                      dropdownColor: Theme.of(context).colorScheme.primary,
                      iconEnabledColor:
                          Theme.of(context).colorScheme.background,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(height: getHeight(context, 0.01)),
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
                      Text(
                        'Attach a photo:'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Take a photo'.tr),
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.pickImage(
                                            source: ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text('Choose from the gallery'.tr),
                                      onTap: () {
                                        Navigator.pop(context);
                                        controller.pickImage(
                                            source: ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.image),
                            label: Text('Attach a photo:'.tr),
                          ),
                          SizedBox(width: 16),
                          Obx(() => controller.selectedImage.value != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    controller.selectedImage.value!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Text(
                                  'No image selected'.tr,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ),
                                )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
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
                            color: Theme.of(context).colorScheme.background,
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
                  onPressed:controller.submitComplaint,
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
