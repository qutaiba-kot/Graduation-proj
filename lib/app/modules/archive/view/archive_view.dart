import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/archive_controller.dart';

class ArchiveView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // العثور على الـ Controller
    final controller = Get.find<ArchiveController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('الشكاوى'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(
          () {
            // التحقق إذا كانت القائمة فارغة
            if (controller.complaints.isEmpty) {
              return Text('لا توجد شكاوى لعرضها.');
            }
            // عرض قائمة الشكاوى
            return ListView.builder(
              itemCount: controller.complaints.length,
              itemBuilder: (context, index) {
                // الحصول على بيانات الشكوى
                final complaint = controller.complaints[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.report, color: Colors.blue),
                    title: Text('حالة الشكوى: ${complaint['status']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('رقم الموقع: ${complaint['location_id']}'),
                        Text('نوع الخطر: ${complaint['hazard_type_id']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
