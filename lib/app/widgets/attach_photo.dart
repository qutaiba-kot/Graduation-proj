import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps/app/modules/reportation/controllers/reportation_controller.dart';

class AttachPhoto extends StatelessWidget {
  final ReportationController controller;
  const AttachPhoto({Key? key, required this.controller}) : super(key: key);
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attach a photo:'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
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
                          Obx(
                            () => controller.selectedImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      controller.selectedImage.value!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Flexible(
                                    child: Text(
                                      'No image selected'.tr,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
  }
}
