import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../assets/hazzard types/hazard_types.dart';
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
        backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
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
            return ListView.builder(
              itemCount: controller.complaints.length,
              itemBuilder: (context, index) {
                final complaint = controller.complaints[index];
                final String status =
                    complaint['status']?.toString() ?? 'Unknown';
                final String locationId =
                    complaint['location_id']?.toString() ?? '';
                final String description =
                    complaint['description']?.toString() ?? 'No Description'.tr;
                final String reportId =
                    complaint['report_id']?.toString() ?? '';
                return Stack(
                  children: [
                    Card(
                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              controller.reportType(description),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold ,color :Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status of the report : '.tr +
                                      controller.statusCheck(status),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                          
                                ),
                                Divider(),
                                Text(
                                  'Type of hazard : '.tr +
                                      (HazardTypeService.getHazardTypeById(
                                                  complaint['hazard_type_id']
                                                      as int)
                                              ?.name ??
                                          'Unknown'),
                                          style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                ),
                                Divider(),
                                Obx(() {
                                  if (!controller.locationCoordinates
                                      .containsKey(locationId)) {
                                    return Text('Loading'.tr);
                                  }
                                  final coordinates = controller
                                      .locationCoordinates[locationId];
                                  return Text('Location'.tr +
                                      ' : ' +
                                      ' ${coordinates?['latitude']}, ${coordinates?['longitude']}' ,style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),);
                                }),
                                Divider(),
                                Text('Description : '.tr + description ,style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),),
                                Divider(),
                              ],
                            ),
                          ),
                          if (reportId.isNotEmpty)
                            Obx(() {
                              if (!controller.photoUrlsMap
                                  .containsKey(reportId)) {
                                controller.fetchPhotosByReportId(reportId);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              final photos =
                                  controller.photoUrlsMap[reportId] ?? [];
                              if (photos.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text('No photo Attatched'.tr , style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),)),
                                );
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: photos.map((photoUrl) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          photoUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.broken_image,
                                                size: 50);
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                    
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 30, 
                        height: 30,
                        decoration: BoxDecoration(
                          color: controller.makeColor(controller
                              .statusCheck(status)),
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(12.0), 
                            bottomRight: Radius.circular(
                                12.0), 
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
